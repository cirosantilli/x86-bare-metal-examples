# No linker script

Hello world using the default `ld` script, not an explicit one set with `-T`. Uses:

- `-tText`
- `.org` inside each assembly file
- `_start` must be present to avoid a warning, since the default linker script expects it

Less stable, but more convenient for quick and dirty tests.
