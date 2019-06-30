# Rough idea for a .schelp to vim help file converter
#
# Use this script on the command line like so: python help_file_converter.py [SomeHelpFile.schelp]
#

import time
import datetime

import sys

# Find in a line the two colons used after tags in the schelp files
# And return the line after those colons
def afterColons(line):
    indexofcolons = line.find("::")
    indexofcolons += 3
    return line[indexofcolons:]

# Strip the schelp tags from a string and replace them with vim help file
# formatting
def cleanSCHelpString(instring):
    # Argument is a help file (as a) string

    newstring = ""

    docTitle=""

    for line in instring.split("\n"):
        # Go through specific lines in the sc doc file tag system
        # And do some kind of formatting with each of them
        if "TITLE::" in line or "title::" in line:
            docTitle = afterColons(line)
            newstring += "---------------------------------\n"
            newstring += "*" + afterColons(line) + "*" + "\n\n"

        elif "METHOD::" in line or "method::" in line:
            newstring += ".*" + afterColons(line) + "*" + "\n"

        elif "DESCRIPTION::" in line or "description::" in line:
            newstring += "Description:" + afterColons(line)  + "~\n"

        elif "CLASSMETHODS::" in line or "classmethods::" in line:
            newstring += "Class methods:" + afterColons(line)  + "~"

        elif "INSTANCEMETHODS::" in line or "instancemethods::" in line:
            newstring += "Class methods:" + afterColons(line)  + "~"

        elif "code::" in line:
            newstring += "// CODE EXAMPLES: " + docTitle + "\n\n"

        elif "returns::" in line:
            newstring += "\treturn: \n\t\t|" + afterColons(line)  + "|\n"

        elif "ARGUMENT::" in line or "argument::" in line:
            newstring +=  "\targ: \n\t\t"

        # All other tags get rinsed for their double colons
        elif "::" in line:
            newstring += afterColons(line) + "\n"

        else: newstring += line + "\n"

    return newstring

# MAIN
def main():
    
    # Setup header + footer text for the new vim help file
    changedate = datetime.datetime.now().strftime("%Y %B %d") 
    headertext = "scdoc.txt" + "\tFor Vim version 7.3" + "\tLast change: " + changedate + "\n \n \n"  
    footertext = "vim:tw=78:ts=4:ft=help:norl:"

    # Load a help file
    inputfile = sys.argv[1] 
    print("Converting {}".format(inputfile))

    with open(inputfile, "r") as schelpfile:
        inputHelpfileString = schelpfile.read()

    # Clean the string from the .schelp file and wrap it in header + footer text
    clean = headertext + cleanSCHelpString(inputHelpfileString) + footertext

    # Strip the suffix from the original help file and use the filename for the
    # new file
    outfilename = inputfile[:inputfile.find(".")] + ".txt"

    outfile = open(outfilename, "w")
    outfile.write(clean)
    outfile.close

    print("Done converting schelp files")

    print(clean)

if __name__ == '__main__':
    main()
