# ANSI library
The asssembly ansi library has three kinds of functions:<br>
1. immeadiate effect<br>
No common prefix<br>
Saves and restores all used registers<br>
Returns nothing<br>
The function generates the ansi command based on the input parameters and writes to stdout<br>
3. save and restore write to buffer<br>
Prefixed with `write`<br>
Saves and restores all used registers<br>
Returns number of bytes written<br>
The function generates the ansi command based on input parameters and writes to buffer<br>
5. clobbered write to buffer<br>
Prefixed with `_write`<br>
Does not save or restore any used registers<br>
Returns nothing<br>
Modifies buffer to point to character after last byte written<br>
The function generates the ansi command based on input parameters and writes to buffer<br>
