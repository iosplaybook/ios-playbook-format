import fs from "node:fs";
import path from "node:path";

const args = process.argv.slice(2);
const useStdin = args.includes("--stdin");

async function main() {
  const filePaths = useStdin ? await readPathsFromStdin() : walkMarkdownFiles("playbooks");

  if (filePaths.length === 0) {
    console.log("No playbook markdown files to validate.");
    return;
  }

  const diagnostics = [];

  for (const filePath of filePaths) {
    if (!filePath.endsWith(".md")) {
      continue;
    }

    if (!fs.existsSync(filePath)) {
      diagnostics.push(makeDiagnostic(filePath, 1, "Changed file no longer exists."));
      continue;
    }

    diagnostics.push(...validateFile(filePath));
  }

  if (diagnostics.length === 0) {
    console.log(`Validated ${filePaths.length} playbook file(s) with no issues.`);
    return;
  }

  for (const diagnostic of diagnostics) {
    emitGitHubError(diagnostic);
    console.error(`${diagnostic.file}:${diagnostic.line} ${diagnostic.message}`);
  }

  console.error("");
  console.error(`Playbook review failed with ${diagnostics.length} issue(s).`);
  process.exitCode = 1;
}

function validateFile(filePath) {
  const raw = fs.readFileSync(filePath, "utf8");
  const lines = raw.split(/\r?\n/);
  const diagnostics = [];

  diagnostics.push(...checkTrailingWhitespace(filePath, lines));
  diagnostics.push(...checkUnreplacedPlaceholders(filePath, lines));
  diagnostics.push(...checkInternalLinks(filePath, lines));
  diagnostics.push(...checkTables(filePath, lines));

  const structureErrors = validateStructure(filePath, lines);
  diagnostics.push(...structureErrors);

  return diagnostics;
}

function validateStructure(filePath, lines) {
  const items = lines
    .map((text, index) => ({ text: text.trim(), line: index + 1 }))
    .filter((item) => item.text.length > 0);

  if (items.length === 0) {
    return [makeDiagnostic(filePath, 1, "Playbook file cannot be empty.")];
  }

  const basename = path.basename(filePath, ".md");
  const type = inferTypeFromFilename(basename);

  if (!type) {
    return [
      makeDiagnostic(
        filePath,
        1,
        "Filename must identify a feature, risk, or control playbook using the platform-feature naming scheme."
      ),
    ];
  }

  if (type === "feature") {
    return validateFeatureFile(filePath, basename, items);
  }

  if (type === "risk") {
    return validateRiskFile(filePath, basename, items);
  }

  return validateControlFile(filePath, basename, items);
}

function validateFeatureFile(filePath, basename, items) {
  const state = createParser(filePath, items);
  const heading = state.expect(/^## (platform-feature-[a-z0-9-]+)$/, "Expected a level-2 feature heading like '## platform-feature-example'.");

  if (!heading) {
    return state.diagnostics;
  }

  const headingSlug = heading.match[1];
  if (headingSlug !== basename) {
    state.error(heading.line, `Filename '${basename}.md' must match heading '${headingSlug}'.`);
    return state.diagnostics;
  }

  state.expectText("### Description", "Expected the '### Description' heading.");
  const description = state.expect(/^The Android platform provides (.+) feature\.$/, "Expected 'The Android platform provides {feature_name} feature.'");
  if (!description) {
    return state.diagnostics;
  }

  const featureName = description.match[1];

  state.expectText("### Additional context", "Expected the '### Additional context' heading.");
  const context = state.expect(/^(.+) is a feature that (.+)\.$/, "Expected '{feature_name} is a feature that {function}.'");
  if (!context) {
    return state.diagnostics;
  }

  if (context.match[1] !== featureName) {
    state.error(context.line, "The feature name in 'Additional context' must match the feature name used in 'Description'.");
    return state.diagnostics;
  }

  state.expectText("### Demonstration", "Expected the '### Demonstration' heading.");
  state.expect(/^Set up .+ with the following configuration:$/, "Expected 'Set up {...} with the following configuration:'.");
  if (state.diagnostics.length > 0) {
    return state.diagnostics;
  }

  state.expectTable("Expected a configuration table after the demonstration setup line.");
  if (state.diagnostics.length > 0) {
    return state.diagnostics;
  }

  const stepsIntro = state.expect(/^Perform the following steps to enable (.+):$/, "Expected 'Perform the following steps to enable {feature_name}:'.");
  if (!stepsIntro) {
    return state.diagnostics;
  }

  if (stepsIntro.match[1] !== featureName) {
    state.error(stepsIntro.line, "The feature name in the demonstration steps must match the feature name used in 'Description'.");
    return state.diagnostics;
  }

  state.expectNumberedList("Expected at least one numbered demonstration step in the form '1. {action_verb} to {objective}'.", /^(\d+)\. .+ to .+$/);
  if (state.diagnostics.length > 0) {
    return state.diagnostics;
  }

  const riskIntro = state.expectOneOf(
    [
      /^Because the Android platform provides (.+) feature, your app is at risk of:$/,
      /^Because the Android platform provides (.+) feature, your$/,
    ],
    "Expected the risk introduction paragraph after the demonstration steps."
  );
  if (!riskIntro) {
    return state.diagnostics;
  }

  if (riskIntro.match[1] !== featureName) {
    state.error(riskIntro.line, "The feature name in the risk introduction must match the feature name used in 'Description'.");
    return state.diagnostics;
  }

  if (riskIntro.text.endsWith("your")) {
    const continuation = state.expect(/^app is at risk of:$/, "Expected the second line of the risk introduction to be 'app is at risk of:'.");
    if (!continuation) {
      return state.diagnostics;
    }
  }

  const riskPattern = new RegExp(`^(\\d+)\\. ${escapeRegex(headingSlug)}-risk-[a-z0-9-]+$`);
  state.expectNumberedList(
    "Expected at least one numbered risk reference like '1. platform-feature-example-risk-something'.",
    riskPattern
  );
  state.expectEnd("Unexpected extra content after the numbered risk references.");
  return state.diagnostics;
}

function validateRiskFile(filePath, basename, items) {
  const state = createParser(filePath, items);
  const heading = state.expect(
    /^## (platform-feature-[a-z0-9-]+-risk-[a-z0-9-]+)$/,
    "Expected a level-2 risk heading like '## platform-feature-example-risk-example'."
  );

  if (!heading) {
    return state.diagnostics;
  }

  const headingSlug = heading.match[1];
  if (headingSlug !== basename) {
    state.error(heading.line, `Filename '${basename}.md' must match heading '${headingSlug}'.`);
    return state.diagnostics;
  }

  state.expectText("### Description", "Expected the '### Description' heading.");
  const description = state.expectOneOf(
    [
      /^Because the Android platform provides (.+) feature, your application is at risk of an attacker (.+)\.$/,
      /^Because the Android platform provides (.+) feature, your application$/,
    ],
    "Expected the risk description paragraph."
  );
  if (!description) {
    return state.diagnostics;
  }

  const featureName = description.match[1];
  let technique = description.match[2] ?? null;

  if (!technique) {
    const continuation = state.expect(
      /^is at risk of an attacker (.+)\.$/,
      "Expected the second line of the risk description to be 'is at risk of an attacker {technique}.'"
    );
    if (!continuation) {
      return state.diagnostics;
    }

    technique = continuation.match[1];
  }

  state.expectText("### Goal", "Expected the '### Goal' heading.");
  state.expect(/^As a result, this could lead to .+\.$/, "Expected 'As a result, this could lead to {tactic}.'");
  if (state.diagnostics.length > 0) {
    return state.diagnostics;
  }

  state.expectText("### Demonstration", "Expected the '### Demonstration' heading.");
  state.expect(/^Set up .+ with the following configuration:$/, "Expected 'Set up {...} with the following configuration:'.");
  if (state.diagnostics.length > 0) {
    return state.diagnostics;
  }

  state.expectTable("Expected a configuration table after the demonstration setup line.");
  if (state.diagnostics.length > 0) {
    return state.diagnostics;
  }

  const stepsIntro = state.expect(
    /^Perform the following steps to demonstrate the risk of an attacker (.+):$/,
    "Expected 'Perform the following steps to demonstrate the risk of an attacker {technique}:'."
  );
  if (!stepsIntro) {
    return state.diagnostics;
  }

  if (stepsIntro.match[1] !== technique) {
    state.error(stepsIntro.line, "The attacker technique in the demonstration steps must match the technique used in 'Description'.");
    return state.diagnostics;
  }

  state.expectNumberedList("Expected at least one numbered demonstration step in the form '1. {action_verb} to {objective}'.", /^(\d+)\. .+ to .+$/);
  state.expectEnd("Unexpected extra content after the demonstration steps.");
  return state.diagnostics;
}

function validateControlFile(filePath, basename, items) {
  const state = createParser(filePath, items);
  const heading = state.expect(
    /^## (platform-feature-[a-z0-9-]+-risk-[a-z0-9-]+-control-[a-z0-9-]+)$/,
    "Expected a level-2 control heading like '## platform-feature-example-risk-example-control-example'."
  );

  if (!heading) {
    return state.diagnostics;
  }

  const headingSlug = heading.match[1];
  if (headingSlug !== basename) {
    state.error(heading.line, `Filename '${basename}.md' must match heading '${headingSlug}'.`);
    return state.diagnostics;
  }

  const intro = state.expect(
    /^Your app can prevent the risk of an attacker (.+) by taking the following steps:$/,
    "Expected 'Your app can prevent the risk of an attacker {technique} by taking the following steps:'."
  );
  if (!intro) {
    return state.diagnostics;
  }

  state.expect(/^1\. Detect by .+$/, "Expected the first control step to be '1. Detect by {instructions}'.");
  state.expect(/^2\. Prevent by .+$/, "Expected the second control step to be '2. Prevent by {instructions}'.");
  state.expect(/^The APK with the implemented control can be found \[here\]\((.+)\)\.$/, "Expected 'The APK with the implemented control can be found [here](path).' at the end of the file.");
  state.expectEnd("Unexpected extra content after the APK link.");
  return state.diagnostics;
}

function createParser(filePath, items) {
  return {
    diagnostics: [],
    index: 0,
    error(line, message) {
      this.diagnostics.push(makeDiagnostic(filePath, line, message));
    },
    current() {
      return items[this.index];
    },
    expect(pattern, message) {
      const item = this.current();
      if (!item) {
        this.error(items.at(-1)?.line ?? 1, message);
        return null;
      }

      const match = item.text.match(pattern);
      if (!match) {
        this.error(item.line, message);
        return null;
      }

      this.index += 1;
      return { ...item, match };
    },
    expectOneOf(patterns, message) {
      const item = this.current();
      if (!item) {
        this.error(items.at(-1)?.line ?? 1, message);
        return null;
      }

      for (const pattern of patterns) {
        const match = item.text.match(pattern);
        if (match) {
          this.index += 1;
          return { ...item, match };
        }
      }

      this.error(item.line, message);
      return null;
    },
    expectText(text, message) {
      return this.expect(new RegExp(`^${escapeRegex(text)}$`), message);
    },
    expectTable(message) {
      const start = this.current();
      if (!start || !start.text.startsWith("|")) {
        this.error(start?.line ?? items.at(-1)?.line ?? 1, message);
        return null;
      }

      const tableLines = [];
      while (this.current() && this.current().text.startsWith("|")) {
        tableLines.push(this.current());
        this.index += 1;
      }

      if (tableLines.length < 3) {
        this.error(start.line, "Configuration tables must include a header, separator, and at least one data row.");
        return null;
      }

      const headerCells = parseTableCells(tableLines[0].text);
      if (headerCells.length !== 2 || headerCells[0] !== "Configuration" || headerCells[1] !== "Detail") {
        this.error(tableLines[0].line, "Configuration tables must use the exact header '| Configuration | Detail |'.");
        return null;
      }

      return tableLines;
    },
    expectNumberedList(message, itemPattern) {
      const start = this.current();
      if (!start || !/^\d+\.\s+/.test(start.text)) {
        this.error(start?.line ?? items.at(-1)?.line ?? 1, message);
        return null;
      }

      let count = 0;
      while (this.current() && /^\d+\.\s+/.test(this.current().text)) {
        const item = this.current();
        if (!itemPattern.test(item.text)) {
          this.error(item.line, message);
          return null;
        }

        count += 1;
        this.index += 1;
      }

      if (count === 0) {
        this.error(start.line, message);
        return null;
      }

      return true;
    },
    expectEnd(message) {
      if (this.current()) {
        this.error(this.current().line, message);
      }
    },
  };
}

function inferTypeFromFilename(basename) {
  if (/^platform-feature-[a-z0-9-]+-risk-[a-z0-9-]+-control-[a-z0-9-]+$/.test(basename)) {
    return "control";
  }

  if (/^platform-feature-[a-z0-9-]+-risk-[a-z0-9-]+$/.test(basename)) {
    return "risk";
  }

  if (/^platform-feature-[a-z0-9-]+$/.test(basename)) {
    return "feature";
  }

  return null;
}

function checkTrailingWhitespace(filePath, lines) {
  const diagnostics = [];

  for (const [index, line] of lines.entries()) {
    if (/[ \t]+$/.test(line)) {
      diagnostics.push(makeDiagnostic(filePath, index + 1, "Trailing whitespace is not allowed."));
    }
  }

  return diagnostics;
}

function checkUnreplacedPlaceholders(filePath, lines) {
  const diagnostics = [];

  for (const [index, line] of lines.entries()) {
    if (/\{[^}]*\}/.test(line) || /[{}]/.test(line)) {
      diagnostics.push(makeDiagnostic(filePath, index + 1, "Placeholders must be fully replaced before review."));
    }
  }

  return diagnostics;
}

function checkInternalLinks(filePath, lines) {
  const diagnostics = [];
  const directory = path.dirname(filePath);
  const linkPattern = /\[[^\]]+\]\(([^)]+)\)/g;

  for (const [index, line] of lines.entries()) {
    for (const match of line.matchAll(linkPattern)) {
      const rawTarget = match[1].trim();
      const target = rawTarget.startsWith("<") && rawTarget.endsWith(">") ? rawTarget.slice(1, -1) : rawTarget;

      if (target.startsWith("http://") || target.startsWith("https://") || target.startsWith("mailto:") || target.startsWith("#")) {
        continue;
      }

      const [relativePath] = target.split("#");
      const resolvedPath = path.resolve(directory, relativePath);

      if (!fs.existsSync(resolvedPath)) {
        diagnostics.push(makeDiagnostic(filePath, index + 1, `Internal link target does not exist: ${relativePath}`));
      }
    }
  }

  return diagnostics;
}

function checkTables(filePath, lines) {
  const diagnostics = [];
  let index = 0;

  while (index < lines.length) {
    if (!lines[index].trim().startsWith("|")) {
      index += 1;
      continue;
    }

    const block = [];
    let lineNumber = index + 1;

    while (index < lines.length && lines[index].trim().startsWith("|")) {
      block.push(lines[index].trim());
      index += 1;
    }

    if (block.length < 3) {
      diagnostics.push(makeDiagnostic(filePath, lineNumber, "Markdown tables must include a header, separator, and at least one data row."));
      continue;
    }

    const widths = block.map(parseTableCells);
    const expectedColumnCount = widths[0].length;

    if (expectedColumnCount < 2) {
      diagnostics.push(makeDiagnostic(filePath, lineNumber, "Markdown tables must contain at least two columns."));
      continue;
    }

    const separatorCells = widths[1];
    if (separatorCells.length !== expectedColumnCount || separatorCells.some((cell) => !/^:?-{3,}:?$/.test(cell))) {
      diagnostics.push(makeDiagnostic(filePath, lineNumber + 1, "The second row of each Markdown table must be a valid separator row."));
    }

    for (let offset = 0; offset < widths.length; offset += 1) {
      if (widths[offset].length !== expectedColumnCount) {
        diagnostics.push(
          makeDiagnostic(
            filePath,
            lineNumber + offset,
            `Table row has ${widths[offset].length} column(s); expected ${expectedColumnCount}.`
          )
        );
      }
    }
  }

  return diagnostics;
}

function parseTableCells(line) {
  return line
    .split("|")
    .slice(1, -1)
    .map((cell) => cell.trim());
}

function walkMarkdownFiles(rootDirectory) {
  if (!fs.existsSync(rootDirectory)) {
    return [];
  }

  const results = [];
  const entries = fs.readdirSync(rootDirectory, { withFileTypes: true });

  for (const entry of entries) {
    const fullPath = path.join(rootDirectory, entry.name);

    if (entry.isDirectory()) {
      results.push(...walkMarkdownFiles(fullPath));
      continue;
    }

    if (entry.isFile() && entry.name.endsWith(".md")) {
      results.push(fullPath);
    }
  }

  return results;
}

function readPathsFromStdin() {
  return new Promise((resolve) => {
    let buffer = "";
    process.stdin.setEncoding("utf8");
    process.stdin.on("data", (chunk) => {
      buffer += chunk;
    });
    process.stdin.on("end", () => {
      resolve(
        buffer
          .split(/\r?\n/)
          .map((line) => line.trim())
          .filter(Boolean)
      );
    });
  });
}

function makeDiagnostic(file, line, message) {
  return { file, line, message };
}

function emitGitHubError({ file, line, message }) {
  const escapedMessage = message.replace(/%/g, "%25").replace(/\r/g, "%0D").replace(/\n/g, "%0A");
  console.log(`::error file=${file},line=${line},title=Playbook validation::${escapedMessage}`);
}

function escapeRegex(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}

await main();
