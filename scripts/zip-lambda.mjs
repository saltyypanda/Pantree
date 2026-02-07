import fs from "node:fs";
import path from "node:path";
import archiver from "archiver";

function usage() {
  console.error("Usage: node scripts/zip-lambda.mjs <distDir> <zipName> <file1> [file2 ...]");
  process.exit(1);
}

const [distDirArg, zipName, ...files] = process.argv.slice(2);
if (!distDirArg || !zipName || files.length === 0) usage();

const distDir = path.resolve(distDirArg);
const zipPath = path.join(distDir, zipName);

// Ensure dist exists
fs.mkdirSync(distDir, { recursive: true });

// Validate input files exist
for (const f of files) {
  const filePath = path.join(distDir, f);
  if (!fs.existsSync(filePath)) {
    console.error(`Missing file: ${filePath}`);
    process.exit(1);
  }
}

// Remove old zip if present
if (fs.existsSync(zipPath)) fs.unlinkSync(zipPath);

const output = fs.createWriteStream(zipPath);
const archive = archiver("zip", { zlib: { level: 9 } });

archive.on("error", (err) => {
  console.error("Archiver error:", err);
  process.exit(1);
});

output.on("close", () => {
  console.log(`OK: wrote ${zipPath} (${archive.pointer()} bytes)`);
});

archive.pipe(output);

// Add files to zip (at root of zip)
for (const f of files) {
  archive.file(path.join(distDir, f), { name: f });
}

await archive.finalize();
