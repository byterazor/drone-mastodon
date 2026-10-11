local base = import 'base.jsonnet';

local secret = {
    new(name='',path='',key=''):: base.new()
                                      .withName(name)
                                      .withKind("secret")
                                      + {get: {
                                            path: path,
                                            name: key
                                      }}
};

secret