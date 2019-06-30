(
var basepath = '/Users/madskjeldgaard/Desktop/scripts/sc';
var path = basepath ++ '/' ++ 'someEvent.scd';

i = (
    init: {|self|
        path.load.value(self);
    }
);
i.init();
)
