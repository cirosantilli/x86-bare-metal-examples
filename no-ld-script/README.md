# No ld script

Hello world using the default `ld` script, no explicit one set with `-T`. Uses:

- `-tText`
- `.org` inside each assembly file
- `_start` must be present to avoid a warning, since the default linker script expects it

Less convenient, but a little less code if you are using a single file.
