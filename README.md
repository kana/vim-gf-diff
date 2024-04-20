
gf-diff is a Vim plugin designed to enhance the functionality of the `gf` command and similar commands within Vim. 
This plugin allows users to open a file and position the cursor at a specific location within a diff hunk directly from the diff output. 
It is particularly useful for reviewing patches and uncommitted changes directly in Vim.

# Features

- Navigate directly to the file and line from a diff output in Vim.
- Supports integration with the gf-user plugin for extended functionality.

# Requirements

- Vim 8.2.1978 or later
- gf-user 1.0.0 or later (vimscript#3891)

# Installation

To install gf-diff, you can use your preferred Vim package manager or manually place the files in your `.vim` directory.

For example, using vim-plug:

```vim
Plug 'kana/vim-gf-user'
Plug 'kana/vim-gf-diff'
```

# Usage

Once installed, gf-diff extends the functionality of the `gf` command. When your cursor is on a line within a diff output, pressing `gf` will attempt to open the corresponding file and jump to the relevant line.

# Functions

- `gf#diff#find()`: This function investigates the hunk under the cursor and navigates accordingly.

# Key Mappings

gf-diff utilizes key mappings provided by the [gf-user](https://github.com/kana/vim-gf-user) plugin. Refer to the gf-user documentation for details on default key mappings and customization.

# Examples

For practical examples and usage scenarios, refer to the gf-user examples section.

# Bugs

- Only supports git diff format currently.
- For additional issues, refer to the gf-user bugs section.

# Changelog

- **1.0.0 (2023-10-09)**: Updated requirements for Vim and gf-user versions.
- **0.1.1 (2012-01-18)**: Improved cursor positioning after file opening.
- **0.1.0 (2012-01-17)**: Integration with gf-user.
- **0.0.0 (2011-12-28)**: Initial release.

# License

gf-diff is released under the MIT License. See the LICENSE file for more details.

# More Information

For the latest version and more details, visit: [gf-diff on GitHub](https://github.com/kana/vim-gf-diff)

For any issues or contributions, please use the GitHub repository to open issues or submit pull requests.

