# "tree" Command

The `tree` command is a Windows command-line tool that displays the directory structure of a specified path or drive in a tree format.

### Usage

tree [drive:][path] [/F] [/A] [/Q] [/R] [/T] [/X] [/K]

### Options
[drive:][path]: Specifies the drive and directory to display the tree structure of. If no path is specified, the current directory is used.

- `/F:` Displays the names of the files in each folder.
- `/A:` Uses ASCII instead of extended characters.
- `/Q:` Encloses directory names in double quotation marks.
- `/R:` Displays the tree structure in a reverse order.
- `/T:` Displays the tree structure with the file sizes.
- `/X:` Prints the short names of files and directories.
- `/K:` Displays the sizes of folders in kilobytes.

### Example
To display the directory tree of the C:\Windows folder with file names and sizes, you would use the following command

```
tree C:\Windows /F /T
```
