


(
~bufferSort = { arg bufferArray = o["voice"];

    var d = Dictionary.new;

    var newBufferArray = Array.new(bufferArray.size);

    var arrayOfBufferSizes = Array.fill(bufferArray.size-1, { |i|

        d.add(bufferArray[i].numFrames.asSymbol -> bufferArray[i])
    
    });

    d.keysValuesArrayDo({|key, value| 

        // IF the current dict item has more frames than the max item in the new
        // list
    if (d.at(key,value) > new) {
        
    }});
};

~bufferSort.value
)

[1,27, 3].maxItem;
