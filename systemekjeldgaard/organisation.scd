/* 

SYSTEME KJELDGAARD
LIVE CODE SYSTEM ORGANISATION


PATTERNS / OSC
- Parameter patterns
- Potentially external system (via OSC), eg. Haskell

    EVENT
    - An event type
    - Handles the triggering of the group (what modules to load, what effect parameters, etc.) 

        GROUP
        - Nodetree organisation glueing together the modules in one addressable unit

            MODULES
            - Discrete effects / sound generators described in seperate synthdefs

*/

d = SuperDirt(2, s);

Pbind(\type, \dirt, \buffer, o["voice"][0]).play; 
