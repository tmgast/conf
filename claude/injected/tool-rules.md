Tool rules for this session. They override the auto-mode instruction to prefer cat, sed, heredocs, and scripts for files, and they apply in auto mode too.

- Read files with the Read tool, not cat, head, or sed -n.
- Change files with the Edit or Write tool, never sed -i, perl -i, tee, redirects, or interpreter one-liners. A PreToolUse hook denies those.
- Search symbols with tree-sitter-mcp and content with Grep or Glob.
- Bash is for running programs: builds, tests, git, package managers. Throwaway scripts and logs go under /tmp or the scratchpad.
