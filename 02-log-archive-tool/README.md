# Log Archive Tool

This project builds a small CLI tool that archives a log directory into a `.tar.gz` file and records when the archive was created.

Project URL: https://roadmap.sh/projects/server-stats

## Requirement

The tool should run like this:

```bash
./log-archive.sh <log-directory>
```

Example:

```bash
./log-archive.sh /var/log
```

It should:

- accept a log directory as an argument
- compress that directory into a `.tar.gz` file
- save the archive inside a new directory
- include date and time in the archive file name
- write an archive history entry to a log file

Example archive name:

```text
logs_archive_20240816_100648.tar.gz
```

## Thinking Process

The important idea is to avoid writing the whole script at once. Break the problem into small questions.

### 1. How does the script receive input?

The user runs:

```bash
./log-archive.sh test-logs
```

In Bash, the first argument is stored in `$1`.

So we save it into a readable variable:

```bash
LOG_DIR=$1
```

Now the script knows which directory the user wants to archive.

### 2. What if the user forgets the argument?

If the user runs:

```bash
./log-archive.sh
```

then `$1` is empty.

We check that with:

```bash
if [ -z "$LOG_DIR" ]; then
```

Meaning:

```text
If LOG_DIR is empty, show usage and stop.
```

The script exits with `exit 1` because this is an error case.

### 3. What if the path is not a directory?

The user may pass a wrong path:

```bash
./log-archive.sh not-exist
```

We check whether the path is an existing directory:

```bash
if [ ! -d "$LOG_DIR" ]; then
```

Meaning:

```text
If LOG_DIR is not a directory, show an error and stop.
```

This prevents `tar` from running on invalid input.

### 4. How do we create the date-time file name?

The project requires a file name like:

```text
logs_archive_20240816_100648.tar.gz
```

The date-time part can be created with:

```bash
date +"%Y%m%d_%H%M%S"
```

Format meaning:

- `%Y` = year
- `%m` = month
- `%d` = day
- `%H` = hour
- `%M` = minute
- `%S` = second

We store it in a variable:

```bash
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
```

Then build the archive name:

```bash
ARCHIVE_NAME="logs_archive_${TIMESTAMP}.tar.gz"
```

### 5. Where should the archive be stored?

The requirement says the compressed logs should be stored in a new directory.

This project uses:

```bash
ARCHIVE_DIR="archives"
```

Then creates it if it does not already exist:

```bash
mkdir -p "$ARCHIVE_DIR"
```

`-p` means:

```text
Create the directory if needed, but do not fail if it already exists.
```

### 6. How do we build the full archive path?

We have:

```bash
ARCHIVE_DIR="archives"
ARCHIVE_NAME="logs_archive_20240816_100648.tar.gz"
```

The final path should be:

```text
archives/logs_archive_20240816_100648.tar.gz
```

So we combine them:

```bash
ARCHIVE_PATH="$ARCHIVE_DIR/$ARCHIVE_NAME"
```

### 7. How do we compress the log directory?

The script uses `tar`:

```bash
tar -czf "$ARCHIVE_PATH" "$LOG_DIR"
```

Options:

- `-c` = create a new archive
- `-z` = compress with gzip
- `-f` = write to the file name that follows

So the command means:

```text
Create a gzip-compressed tar archive at ARCHIVE_PATH from LOG_DIR.
```

### 8. How do we know if `tar` worked?

After a command runs, Bash stores its exit code in `$?`.

- `0` means success
- anything else means failure

So the script checks:

```bash
if [ $? -eq 0 ]; then
```

If it worked, the script prints success and writes to the archive log.

If it failed, the script prints an error and exits.

### 9. How do we log archive history?

The project requires recording the date and time of the archive.

This script stores history in:

```text
archives/archive.log
```

It creates a human-readable timestamp:

```bash
LOG_TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
```

Then appends one line to the log file:

```bash
echo "$LOG_TIMESTAMP Archived '$LOG_DIR' to '$ARCHIVE_PATH'" >> "$LOG_FILE"
```

The `>>` operator appends to the file instead of replacing it.

## Final Flow

The final script follows this order:

1. Read the log directory from `$1`
2. Stop if no argument was provided
3. Stop if the argument is not a directory
4. Create timestamps
5. Build the archive file name
6. Create the `archives` directory
7. Build the full archive path
8. Run `tar`
9. If successful, write to `archives/archive.log`
10. If failed, show an error

## Usage

From this project directory:

```bash
chmod +x log-archive.sh
./log-archive.sh test-logs
```

Expected output:

```text
Archive created: archives/logs_archive_<timestamp>.tar.gz
Archive log updated: archives/archive.log
```

Check generated archives:

```bash
ls archives
```

Check archive history:

```bash
cat archives/archive.log
```

Inspect archive contents:

```bash
tar -tzf archives/logs_archive_<timestamp>.tar.gz
```

## Notes

Archiving `/var/log` may fail for some files because normal users do not always have permission to read every system log. For learning and testing, start with a small test directory like `test-logs`.
