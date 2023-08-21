#!/bin/bash
# this script based http://ipv4.web.fc2.com/map-e.html & https://benedicam-te.blogspot.com/

. /lib/functions/network.sh
network_flush_cache
network_find_wan NET_IF
network_find_wan6 NET_IF6
network_get_ipaddr NET_ADDR "${NET_IF}"
network_get_ipaddr6 NET_ADDR6 "${NET_IF6}"
network_get_device NET_L3D "${NET_IF}"
new_ip6_prefix=${NET_ADDR6}


declare -A ruleprefix31=(
  [0x240b0010]=106,72
  [0x240b0012]=14,8
  [0x240b0250]=14,10
  [0x240b0252]=14,12
  [0x24047a80]=133,200
  [0x24047a84]=133,206
)
declare -A ruleprefix38=(
  [0x24047a8200]=125,196,208
  [0x24047a8204]=125,196,212
  [0x24047a8208]=125,198,140
  [0x24047a820c]=125,198,144
  [0x24047a8210]=125,198,212
  [0x24047a8214]=125,198,244
  [0x24047a8218]=122,131,104
  [0x24047a821c]=125,195,20
  [0x24047a8220]=133,203,160
  [0x24047a8224]=133,203,164
  [0x24047a8228]=133,203,168
  [0x24047a822c]=133,203,172
  [0x24047a8230]=133,203,176
  [0x24047a8234]=133,203,180
  [0x24047a8238]=133,203,184
  [0x24047a823c]=133,203,188
  [0x24047a8240]=133,209,0
  [0x24047a8244]=133,209,4
  [0x24047a8248]=133,209,8
  [0x24047a824c]=133,209,12
  [0x24047a8250]=133,209,16
  [0x24047a8254]=133,209,20
  [0x24047a8258]=133,209,24
  [0x24047a825c]=133,209,28
  [0x24047a8260]=133,204,192
  [0x24047a8264]=133,204,196
  [0x24047a8268]=133,204,200
  [0x24047a826c]=133,204,204
  [0x24047a8270]=133,204,208
  [0x24047a8274]=133,204,212
  [0x24047a8278]=133,204,216
  [0x24047a827c]=133,204,220
  [0x24047a8280]=133,203,224
  [0x24047a8284]=133,203,228
  [0x24047a8288]=133,203,232
  [0x24047a828c]=133,203,236
  [0x24047a8290]=133,203,240
  [0x24047a8294]=133,203,244
  [0x24047a8298]=133,203,248
  [0x24047a829c]=133,203,252
  [0x24047a82a0]=125,194,192
  [0x24047a82a4]=125,194,196
  [0x24047a82a8]=125,194,200
  [0x24047a82ac]=125,194,204
  [0x24047a82b0]=119,239,128
  [0x24047a82b4]=119,239,132
  [0x24047a82b8]=119,239,136
  [0x24047a82bc]=119,239,140
  [0x24047a82c0]=125,194,32
  [0x24047a82c4]=125,194,36
  [0x24047a82c8]=125,194,40
  [0x24047a82cc]=125,194,44
  [0x24047a82d0]=125,195,24
  [0x24047a82d4]=125,195,28
  [0x24047a82d8]=122,130,192
  [0x24047a82dc]=122,130,196
  [0x24047a82e0]=122,135,64
  [0x24047a82e4]=122,135,68
  [0x24047a82e8]=125,192,240
  [0x24047a82ec]=125,192,244
  [0x24047a82f0]=125,193,176
  [0x24047a82f4]=125,193,180
  [0x24047a82f8]=122,130,176
  [0x24047a82fc]=122,130,180
  [0x24047a8300]=122,131,24
  [0x24047a8304]=122,131,28
  [0x24047a8308]=122,131,32
  [0x24047a830c]=122,131,36
  [0x24047a8310]=119,243,112
  [0x24047a8314]=119,243,116
  [0x24047a8318]=219,107,136
  [0x24047a831c]=219,107,140
  [0x24047a8320]=220,144,224
  [0x24047a8324]=220,144,228
  [0x24047a8328]=125,194,64
  [0x24047a832c]=125,194,68
  [0x24047a8330]=221,171,40
  [0x24047a8334]=221,171,44
  [0x24047a8338]=110,233,80
  [0x24047a833c]=110,233,84
  [0x24047a8340]=119,241,184
  [0x24047a8344]=119,241,188
  [0x24047a8348]=119,243,56
  [0x24047a834c]=119,243,60
  [0x24047a8350]=125,199,8
  [0x24047a8354]=125,199,12
  [0x24047a8358]=125,196,96
  [0x24047a835c]=125,196,100
  [0x24047a8360]=122,130,104
  [0x24047a8364]=122,130,108
  [0x24047a8368]=122,130,112
  [0x24047a836c]=122,130,116
  [0x24047a8370]=49,129,152
  [0x24047a8374]=49,129,156
  [0x24047a8378]=49,129,192
  [0x24047a837c]=49,129,196
  [0x24047a8380]=49,129,120
  [0x24047a8384]=49,129,124
  [0x24047a8388]=221,170,40
  [0x24047a838c]=221,170,44
  [0x24047a8390]=60,239,108
  [0x24047a8394]=60,236,24
  [0x24047a8398]=122,130,120
  [0x24047a839c]=60,236,84
  [0x24047a83a0]=60,239,180
  [0x24047a83a4]=60,239,184
  [0x24047a83a8]=118,110,136
  [0x24047a83ac]=119,242,136
  [0x24047a83b0]=60,238,188
  [0x24047a83b4]=60,238,204
  [0x24047a83b8]=122,134,52
  [0x24047a83bc]=119,244,60
  [0x24047a83c0]=119,243,100
  [0x24047a83c4]=221,170,236
  [0x24047a83c8]=221,171,48
  [0x24047a83cc]=60,238,36
  [0x24047a83d0]=125,195,236
  [0x24047a83d4]=60,236,20
  [0x24047a83d8]=118,108,76
  [0x24047a83dc]=118,110,108
  [0x24047a83e0]=118,110,112
  [0x24047a83e4]=118,111,88
  [0x24047a83e8]=118,111,228
  [0x24047a83ec]=118,111,236
  [0x24047a83f0]=119,241,148
  [0x24047a83f4]=119,242,124
  [0x24047a83f8]=125,194,28
  [0x24047a83fc]=125,194,96
  [0x24047a8600]=133,204,128
  [0x24047a8604]=133,204,132
  [0x24047a8608]=133,204,136
  [0x24047a860c]=133,204,140
  [0x24047a8610]=133,204,144
  [0x24047a8614]=133,204,148
  [0x24047a8618]=133,204,152
  [0x24047a861c]=133,204,156
  [0x24047a8620]=133,204,160
  [0x24047a8624]=133,204,164
  [0x24047a8628]=133,204,168
  [0x24047a862c]=133,204,172
  [0x24047a8630]=133,204,176
  [0x24047a8634]=133,204,180
  [0x24047a8638]=133,204,184
  [0x24047a863c]=133,204,188
  [0x24047a8640]=133,203,192
  [0x24047a8644]=133,203,196
  [0x24047a8648]=133,203,200
  [0x24047a864c]=133,203,204
  [0x24047a8650]=133,203,208
  [0x24047a8654]=133,203,212
  [0x24047a8658]=133,203,216
  [0x24047a865c]=133,203,220
  [0x24047a8660]=133,204,0
  [0x24047a8664]=133,204,4
  [0x24047a8668]=133,204,8
  [0x24047a866c]=133,204,12
  [0x24047a8670]=133,204,16
  [0x24047a8674]=133,204,20
  [0x24047a8678]=133,204,24
  [0x24047a867c]=133,204,28
  [0x24047a8680]=133,204,64
  [0x24047a8684]=133,204,68
  [0x24047a8688]=133,204,72
  [0x24047a868c]=133,204,76
  [0x24047a8690]=133,204,80
  [0x24047a8694]=133,204,84
  [0x24047a8698]=133,204,88
  [0x24047a869c]=133,204,92
  [0x24047a86a0]=221,171,112
  [0x24047a86a4]=221,171,116
  [0x24047a86a8]=221,171,120
  [0x24047a86ac]=221,171,124
  [0x24047a86b0]=125,195,184
  [0x24047a86b4]=125,196,216
  [0x24047a86b8]=221,171,108
  [0x24047a86bc]=219,107,152
  [0x24047a86c0]=60,239,128
  [0x24047a86c4]=60,239,132
  [0x24047a86c8]=60,239,136
  [0x24047a86cc]=60,239,140
  [0x24047a86d0]=118,110,80
  [0x24047a86d4]=118,110,84
  [0x24047a86d8]=118,110,88
  [0x24047a86dc]=118,110,92
  [0x24047a86e0]=125,194,176
  [0x24047a86e4]=125,194,180
  [0x24047a86e8]=125,194,184
  [0x24047a86ec]=125,194,188
  [0x24047a86f0]=60,239,112
  [0x24047a86f4]=60,239,116
  [0x24047a86f8]=60,239,120
  [0x24047a86fc]=60,239,124
  [0x24047a8700]=125,195,56
  [0x24047a8704]=125,195,60
  [0x24047a8708]=125,196,32
  [0x24047a870c]=125,196,36
  [0x24047a8710]=118,108,80
  [0x24047a8714]=118,108,84
  [0x24047a8718]=118,111,80
  [0x24047a871c]=118,111,84
  [0x24047a8720]=218,227,176
  [0x24047a8724]=218,227,180
  [0x24047a8728]=60,239,208
  [0x24047a872c]=60,239,212
  [0x24047a8730]=118,109,56
  [0x24047a8734]=118,109,60
  [0x24047a8738]=122,131,88
  [0x24047a873c]=122,131,92
  [0x24047a8740]=122,131,96
  [0x24047a8744]=122,131,100
  [0x24047a8748]=122,130,48
  [0x24047a874c]=122,130,52
  [0x24047a8750]=125,198,224
  [0x24047a8754]=125,198,228
  [0x24047a8758]=119,243,104
  [0x24047a875c]=119,243,108
  [0x24047a8760]=118,109,152
  [0x24047a8764]=118,109,156
  [0x24047a8768]=118,111,104
  [0x24047a876c]=118,111,108
  [0x24047a8770]=119,239,48
  [0x24047a8774]=119,239,52
  [0x24047a8778]=122,130,16
  [0x24047a877c]=122,130,20
  [0x24047a8780]=125,196,128
  [0x24047a8784]=125,196,132
  [0x24047a8788]=122,131,48
  [0x24047a878c]=122,131,52
  [0x24047a8790]=122,134,104
  [0x24047a8794]=122,134,108
  [0x24047a8798]=60,238,208
  [0x24047a879c]=60,238,212
  [0x24047a87a0]=220,144,192
  [0x24047a87a4]=220,144,196
  [0x24047a87a8]=110,233,48
  [0x24047a87ac]=122,131,84
  [0x24047a87b0]=111,169,152
  [0x24047a87b4]=119,241,132
  [0x24047a87b8]=119,241,136
  [0x24047a87bc]=119,244,68
  [0x24047a87c0]=60,236,92
  [0x24047a87c4]=60,237,108
  [0x24047a87c8]=60,238,12
  [0x24047a87cc]=60,238,44
  [0x24047a87d0]=60,238,216
  [0x24047a87d4]=60,238,232
  [0x24047a87d8]=49,129,72
  [0x24047a87dc]=110,233,4
  [0x24047a87e0]=110,233,192
  [0x24047a87e4]=119,243,20
  [0x24047a87e8]=119,243,24
  [0x24047a87ec]=125,193,4
  [0x24047a87f0]=125,193,148
  [0x24047a87f4]=118,110,76
  [0x24047a87f8]=118,110,96
  [0x24047a87fc]=125,193,152
)
declare -A ruleprefix38_20=(
  [0x2400405000]=153,240,0
  [0x2400405004]=153,240,16
  [0x2400405008]=153,240,32
  [0x240040500c]=153,240,48
  [0x2400405010]=153,240,64
  [0x2400405014]=153,240,80
  [0x2400405018]=153,240,96
  [0x240040501c]=153,240,112
  [0x2400405020]=153,240,128
  [0x2400405024]=153,240,144
  [0x2400405028]=153,240,160
  [0x240040502c]=153,240,176
  [0x2400405030]=153,240,192
  [0x2400405034]=153,240,208
  [0x2400405038]=153,240,224
  [0x240040503c]=153,240,240
  [0x2400405040]=153,241,0
  [0x2400405044]=153,241,16
  [0x2400405048]=153,241,32
  [0x240040504c]=153,241,48
  [0x2400405050]=153,241,64
  [0x2400405054]=153,241,80
  [0x2400405058]=153,241,96
  [0x240040505c]=153,241,112
  [0x2400405060]=153,241,128
  [0x2400405064]=153,241,144
  [0x2400405068]=153,241,160
  [0x240040506c]=153,241,176
  [0x2400405070]=153,241,192
  [0x2400405074]=153,241,208
  [0x2400405078]=153,241,224
  [0x240040507c]=153,241,240
  [0x2400405080]=153,242,0
  [0x2400405084]=153,242,16
  [0x2400405088]=153,242,32
  [0x240040508c]=153,242,48
  [0x2400405090]=153,242,64
  [0x2400405094]=153,242,80
  [0x2400405098]=153,242,96
  [0x240040509c]=153,242,112
  [0x24004050a0]=153,242,128
  [0x24004050a4]=153,242,144
  [0x24004050a8]=153,242,160
  [0x24004050ac]=153,242,176
  [0x24004050b0]=153,242,192
  [0x24004050b4]=153,242,208
  [0x24004050b8]=153,242,224
  [0x24004050bc]=153,242,240
  [0x24004050c0]=153,243,0
  [0x24004050c4]=153,243,16
  [0x24004050c8]=153,243,32
  [0x24004050cc]=153,243,48
  [0x24004050d0]=153,243,64
  [0x24004050d4]=153,243,80
  [0x24004050d8]=153,243,96
  [0x24004050dc]=153,243,112
  [0x24004050e0]=153,243,128
  [0x24004050e4]=153,243,144
  [0x24004050e8]=153,243,160
  [0x24004050ec]=153,243,176
  [0x24004050f0]=153,243,192
  [0x24004050f4]=153,243,208
  [0x24004050f8]=153,243,224
  [0x24004050fc]=153,243,240
  [0x2400405100]=122,26,0
  [0x2400405104]=122,26,16
  [0x2400405108]=122,26,32
  [0x240040510c]=122,26,48
  [0x2400405110]=122,26,64
  [0x2400405114]=122,26,80
  [0x2400405118]=122,26,96
  [0x240040511c]=122,26,112
  [0x2400405120]=114,146,64
  [0x2400405124]=114,146,80
  [0x2400405128]=114,146,96
  [0x240040512c]=114,146,112
  [0x2400405130]=114,148,192
  [0x2400405134]=114,148,208
  [0x2400405138]=114,148,224
  [0x240040513c]=114,148,240
  [0x2400405140]=114,150,192
  [0x2400405144]=114,150,208
  [0x2400405148]=114,150,224
  [0x240040514c]=114,150,240
  [0x2400405150]=114,163,64
  [0x2400405154]=114,163,80
  [0x2400405158]=114,163,96
  [0x240040515c]=114,163,112
  [0x2400405180]=114,172,192
  [0x2400405184]=114,172,208
  [0x2400405188]=114,172,224
  [0x240040518c]=114,172,240
  [0x2400405190]=114,177,64
  [0x2400405194]=114,177,80
  [0x2400405198]=114,177,96
  [0x240040519c]=114,177,112
  [0x24004051a0]=118,0,64
  [0x24004051a4]=118,0,80
  [0x24004051a8]=118,0,96
  [0x24004051ac]=118,0,112
  [0x24004051b0]=118,7,64
  [0x24004051b4]=118,7,80
  [0x24004051b8]=118,7,96
  [0x24004051bc]=118,7,112
  [0x2400405200]=123,225,192
  [0x2400405204]=123,225,208
  [0x2400405208]=123,225,224
  [0x240040520c]=123,225,240
  [0x2400405210]=153,134,0
  [0x2400405214]=153,134,16
  [0x2400405218]=153,134,32
  [0x240040521c]=153,134,48
  [0x2400405220]=153,139,128
  [0x2400405224]=153,139,144
  [0x2400405228]=153,139,160
  [0x240040522c]=153,139,176
  [0x2400405230]=153,151,64
  [0x2400405234]=153,151,80
  [0x2400405238]=153,151,96
  [0x240040523c]=153,151,112
  [0x24004051c0]=118,8,192
  [0x24004051c4]=118,8,208
  [0x24004051c8]=118,8,224
  [0x24004051cc]=118,8,240
  [0x24004051d0]=118,9,0
  [0x24004051d4]=118,9,16
  [0x24004051d8]=118,9,32
  [0x24004051dc]=118,9,48
  [0x24004051e0]=123,218,64
  [0x24004051e4]=123,218,80
  [0x24004051e8]=123,218,96
  [0x24004051ec]=123,218,112
  [0x24004051f0]=123,220,128
  [0x24004051f4]=123,220,144
  [0x24004051f8]=123,220,160
  [0x24004051fc]=123,220,176
  [0x2400405240]=153,170,64
  [0x2400405244]=153,170,80
  [0x2400405248]=153,170,96
  [0x240040524c]=153,170,112
  [0x2400405250]=153,170,192
  [0x2400405254]=153,170,208
  [0x2400405258]=153,170,224
  [0x240040525c]=153,170,240
  [0x2400405260]=61,127,128
  [0x2400405264]=61,127,144
  [0x2400405268]=114,146,0
  [0x240040526c]=114,146,16
  [0x2400405270]=114,146,128
  [0x2400405274]=114,146,144
  [0x2400405278]=114,148,64
  [0x240040527c]=114,148,80
  [0x2400405280]=114,148,160
  [0x2400405284]=114,148,176
  [0x2400405288]=114,149,0
  [0x240040528c]=114,149,16
  [0x2400405290]=114,150,160
  [0x2400405294]=114,150,176
  [0x2400405298]=114,158,0
  [0x240040529c]=114,158,16
  [0x2400405160]=114,163,128
  [0x2400405164]=114,163,144
  [0x2400405168]=114,163,160
  [0x240040516c]=114,163,176
  [0x2400405170]=114,167,64
  [0x2400405174]=114,167,80
  [0x2400405178]=114,167,96
  [0x240040517c]=114,167,112
  [0x2400405300]=114,162,128
  [0x2400405304]=114,162,144
  [0x2400405308]=114,163,0
  [0x240040530c]=114,163,16
  [0x2400405310]=114,165,224
  [0x2400405314]=114,165,240
  [0x2400405318]=114,167,192
  [0x240040531c]=114,167,208
  [0x2400405320]=114,177,128
  [0x2400405324]=114,177,144
  [0x2400405328]=114,178,224
  [0x240040532c]=114,178,240
  [0x2400405330]=118,1,0
  [0x2400405334]=118,1,16
  [0x2400405338]=118,3,192
  [0x240040533c]=118,3,208
  [0x2400405340]=118,6,64
  [0x2400405344]=118,6,80
  [0x2400405348]=118,7,160
  [0x240040534c]=118,7,176
  [0x2400405360]=118,9,128
  [0x2400405364]=118,9,144
  [0x2400405368]=118,22,128
  [0x240040536c]=118,22,144
  [0x2400405370]=122,16,0
  [0x2400405374]=122,16,16
  [0x2400405378]=123,220,0
  [0x240040537c]=123,220,16
  [0x2400405350]=118,7,192
  [0x2400405354]=118,7,208
  [0x2400405358]=118,9,64
  [0x240040535c]=118,9,80
  [0x2400405380]=153,173,0
  [0x2400405384]=153,173,16
  [0x2400405388]=153,173,32
  [0x240040538c]=153,173,48
  [0x2400405390]=153,173,64
  [0x2400405394]=153,173,80
  [0x2400405398]=153,173,96
  [0x240040539c]=153,173,112
  [0x24004053a0]=153,173,128
  [0x24004053a4]=153,173,144
  [0x24004053a8]=153,173,160
  [0x24004053ac]=153,173,176
  [0x24004053b0]=153,173,192
  [0x24004053b4]=153,173,208
  [0x24004053b8]=153,173,224
  [0x24004053bc]=153,173,240
  [0x24004053c0]=153,238,0
  [0x24004053c4]=153,238,16
  [0x24004053c8]=153,238,32
  [0x24004053cc]=153,238,48
  [0x24004053d0]=153,238,64
  [0x24004053d4]=153,238,80
  [0x24004053d8]=153,238,96
  [0x24004053dc]=153,238,112
  [0x24004053e0]=153,238,128
  [0x24004053e4]=153,238,144
  [0x24004053e8]=153,238,160
  [0x24004053ec]=153,238,176
  [0x24004053f0]=153,238,192
  [0x24004053f4]=153,238,208
  [0x24004053f8]=153,238,224
  [0x24004053fc]=153,238,240
  [0x2400415000]=153,239,0
  [0x2400415004]=153,239,16
  [0x2400415008]=153,239,32
  [0x240041500c]=153,239,48
  [0x2400415010]=153,239,64
  [0x2400415014]=153,239,80
  [0x2400415018]=153,239,96
  [0x240041501c]=153,239,112
  [0x2400415020]=153,239,128
  [0x2400415024]=153,239,144
  [0x2400415028]=153,239,160
  [0x240041502c]=153,239,176
  [0x2400415030]=153,239,192
  [0x2400415034]=153,239,208
  [0x2400415038]=153,239,224
  [0x240041503c]=153,239,240
  [0x2400415040]=153,252,0
  [0x2400415044]=153,252,16
  [0x2400415048]=153,252,32
  [0x240041504c]=153,252,48
  [0x2400415050]=153,252,64
  [0x2400415054]=153,252,80
  [0x2400415058]=153,252,96
  [0x240041505c]=153,252,112
  [0x2400415060]=153,252,128
  [0x2400415064]=153,252,144
  [0x2400415068]=153,252,160
  [0x240041506c]=153,252,176
  [0x2400415070]=153,252,192
  [0x2400415074]=153,252,208
  [0x2400415078]=153,252,224
  [0x240041507c]=153,252,240
  [0x2400415080]=123,222,96
  [0x2400415084]=123,222,112
  [0x2400415088]=123,225,96
  [0x240041508c]=123,225,112
  [0x2400415090]=123,225,160
  [0x2400415094]=123,225,176
  [0x2400415098]=124,84,96
  [0x240041509c]=124,84,112
  [0x2400415380]=180,12,128
  [0x2400415384]=180,12,144
  [0x2400415388]=180,26,96
  [0x240041538c]=180,26,112
  [0x2400415390]=180,26,160
  [0x2400415394]=180,26,176
  [0x2400415398]=180,26,224
  [0x240041539c]=180,26,240
  [0x24004153a0]=180,30,0
  [0x24004153a4]=180,30,16
  [0x24004153a8]=180,31,96
  [0x24004153ac]=180,31,112
  [0x24004153c0]=180,46,0
  [0x24004153c4]=180,46,16
  [0x24004153c8]=180,48,0
  [0x24004153cc]=180,48,16
  [0x24004153d0]=180,50,192
  [0x24004153d4]=180,50,208
  [0x24004153d8]=180,53,0
  [0x24004153dc]=180,53,16
  [0x24004153b0]=180,32,64
  [0x24004153b4]=180,32,80
  [0x24004153b8]=180,34,160
  [0x24004153bc]=180,34,176
  [0x24004153e0]=218,230,128
  [0x24004153e4]=218,230,144
  [0x24004153e8]=219,161,64
  [0x24004153ec]=219,161,80
  [0x24004153f0]=220,96,64
  [0x24004153f4]=220,96,80
  [0x24004153f8]=220,99,0
  [0x24004153fc]=220,99,16
  [0x2400415100]=180,60,0
  [0x2400415104]=180,60,16
  [0x2400415108]=180,60,32
  [0x240041510c]=180,60,48
  [0x2400415110]=180,60,64
  [0x2400415114]=180,60,80
  [0x2400415118]=180,60,96
  [0x240041511c]=180,60,112
  [0x2400415120]=180,60,128
  [0x2400415124]=180,60,144
  [0x2400415128]=180,60,160
  [0x240041512c]=180,60,176
  [0x2400415130]=180,60,192
  [0x2400415134]=180,60,208
  [0x2400415138]=180,60,224
  [0x240041513c]=180,60,240
  [0x2400415140]=153,139,0
  [0x2400415144]=153,139,16
  [0x2400415148]=153,139,32
  [0x240041514c]=153,139,48
  [0x2400415150]=153,139,64
  [0x2400415154]=153,139,80
  [0x2400415158]=153,139,96
  [0x240041515c]=153,139,112
  [0x2400415160]=219,161,128
  [0x2400415164]=219,161,144
  [0x2400415168]=219,161,160
  [0x240041516c]=219,161,176
  [0x2400415170]=219,161,192
  [0x2400415174]=219,161,208
  [0x2400415178]=219,161,224
  [0x240041517c]=219,161,240
  [0x24004151c0]=124,84,128
  [0x24004151c4]=124,84,144
  [0x24004151c8]=124,98,192
  [0x24004151cc]=124,98,208
  [0x2400415180]=153,187,0
  [0x2400415184]=153,187,16
  [0x2400415188]=153,187,32
  [0x240041518c]=153,187,48
  [0x2400415190]=153,191,0
  [0x2400415194]=153,191,16
  [0x2400415198]=153,191,32
  [0x240041519c]=153,191,48
  [0x24004151a0]=180,12,64
  [0x24004151a4]=180,12,80
  [0x24004151a8]=180,12,96
  [0x24004151ac]=180,12,112
  [0x24004151b0]=180,13,0
  [0x24004151b4]=180,13,16
  [0x24004151b8]=180,13,32
  [0x24004151bc]=180,13,48
  [0x24004151d0]=124,100,0
  [0x24004151d4]=124,100,16
  [0x24004151d8]=124,100,224
  [0x24004151dc]=124,100,240
  [0x2400415300]=153,165,96
  [0x2400415304]=153,165,112
  [0x2400415308]=153,165,160
  [0x240041530c]=153,165,176
  [0x2400415310]=153,171,224
  [0x2400415314]=153,171,240
  [0x2400415318]=153,175,0
  [0x240041531c]=153,175,16
  [0x2400415344]=220,106,48
  [0x2400415374]=220,106,80
  [0x2400415340]=220,106,32
  [0x2400415370]=220,106,64
  [0x2400415320]=153,181,0
  [0x2400415324]=153,181,16
  [0x2400415328]=153,183,224
  [0x240041532c]=153,183,240
  [0x2400415330]=153,184,128
  [0x2400415334]=153,184,144
  [0x2400415338]=153,187,224
  [0x240041533c]=153,187,240
  [0x2400415360]=153,191,192
  [0x2400415364]=153,191,208
  [0x2400415348]=153,188,0
  [0x240041534c]=153,188,16
  [0x2400415350]=153,190,128
  [0x2400415354]=153,190,144
  [0x2400415358]=153,191,64
  [0x240041535c]=153,191,80
  [0x2400415368]=153,194,96
  [0x240041536c]=153,194,112
  [0x2400415200]=180,16,0
  [0x2400415204]=180,16,16
  [0x2400415208]=180,16,32
  [0x240041520c]=180,16,48
  [0x2400415210]=180,29,128
  [0x2400415214]=180,29,144
  [0x2400415218]=180,29,160
  [0x240041521c]=180,29,176
  [0x2400415220]=180,59,64
  [0x2400415224]=180,59,80
  [0x2400415228]=180,59,96
  [0x240041522c]=180,59,112
  [0x2400415230]=219,161,0
  [0x2400415234]=219,161,16
  [0x2400415238]=219,161,32
  [0x240041523c]=219,161,48
  [0x2400415250]=153,131,96
  [0x2400415254]=153,131,112
  [0x2400415260]=153,131,128
  [0x2400415264]=153,131,144
  [0x2400415268]=153,132,128
  [0x240041526c]=153,132,144
  [0x2400415240]=153,129,160
  [0x2400415244]=153,129,176
  [0x2400415248]=153,130,0
  [0x240041524c]=153,130,16
  [0x2400415270]=153,134,64
  [0x2400415274]=153,134,80
  [0x2400415278]=153,137,0
  [0x240041527c]=153,137,16
  [0x2400415280]=153,139,192
  [0x2400415284]=153,139,208
  [0x2400415288]=153,151,32
  [0x240041528c]=153,151,48
  [0x2400415290]=153,156,96
  [0x2400415294]=153,156,112
  [0x2400415298]=153,156,128
  [0x240041529c]=153,156,144
)

ip6_prefix_tmp=`echo ${new_ip6_prefix/::/:0::}`
if [[ $ip6_prefix_tmp =~ ^([0-9a-f]{1,4}):([0-9a-f]{1,4}):([0-9a-f]{1,4}):([0-9a-f]{0,4}) ]]; then

  tmp=( $( echo ${ip6_prefix_tmp} | sed -e "s|:| |g" ) )

  for i in {0..3}; do
    if [ -z "${tmp[$i]}" ];then tmp[$i]=0;fi
    hextet[i]=`printf %d 0x${tmp[$i]}`
  done
else
  echo "プレフィックスを認識できません"
  exit 1  
fi

prefix31=$(( $(( ${hextet[0]} * 0x10000 )) + $((${hextet[1]} & 0xfffe)) ))
prefix38=$(( $(( ${hextet[0]} * 0x1000000 )) + $(( ${hextet[1]} * 0x100 )) + $(( $(( ${hextet[2]} & 0xfc00 )) >> 8 )) ))
offset=6
rfc=false
if [ -n "${ruleprefix38[`printf 0x%x $prefix38`]}" ]; then
  octet="${ruleprefix38[`printf 0x%x $prefix38`]}"
# replace "," to the array delimiter " " to split into an array
  octet=(${octet//,/ }) 
  octet[2]=$(( ${octet[2]} | $(( $(( ${hextet[2]} & 0x0300 )) >> 8 )) )) 
  octet[3]=$(( ${hextet[2]} & 0x00ff )) 
#  echo debug: ${octet[0]} ${octet[1]} ${octet[2]} ${octet[3]} 
  ipaddr="${ruleprefix38[`printf 0x%x $prefix38`]}",0
  ip6prefixlen=38
  psidlen=8 
  offset=4
elif [ -n "${ruleprefix31[`printf 0x%x $prefix31`]}" ]; then 
  octet="${ruleprefix31[`printf 0x%x $prefix31`]}" 
  octet=(${octet//,/ }) 
  octet[1]=$(( ${octet[1]} | $(( ${hextet[1]} & 0x0001 )) )) 
  octet[2]=$(( $(( ${hextet[2]} & 0xff00 )) >> 8 ))
  octet[3]=$(( ${hextet[2]} & 0x00ff ))
  ipaddr="${ruleprefix31[`printf 0x%x $prefix31`]}",0,0
  ip6prefixlen=31
  psidlen=8
  offset=4
elif [ -n "${ruleprefix38_20[`printf 0x%x $prefix38`]}" ]; then 
  octet="${ruleprefix38_20[`printf 0x%x $prefix38`]}"
  octet=(${octet//,/ }) 
  octet[2]=$(( ${octet[2]} | $(( $(( ${hextet[2]} & 0x03c0 )) >> 6 )) ))
  octet[3]=$(( $(( $(( ${hextet[2]} & 0x003f )) << 2 )) | $(( $(( ${hextet[3]} & 0xc000 )) >> 14 )) )) 
  ipaddr="${ruleprefix38_20[`printf 0x%x $prefix38`]}",0
  ip6prefixlen=38
  psidlen=6
else
  echo "未対応のプレフィックス"
  exit 1 
fi

if [ $psidlen == 8 ]; then
  psid=$(( $(( ${hextet[3]} & 0xff00 )) >> 8 ))
elif [ $psidlen == 6 ]; then
  psid=$(( $(( ${hextet[3]} & 0x3f00 )) >> 8 ))
fi

ports=""
Amax=$(( $(( 1 << $offset )) -1 ));
for (( A=1; A <= $Amax; A++ )) {
  port=$(( $(( $A << $((16 - $offset)) )) | $(( $psid << $(( 16 - $offset - $psidlen )) )) ))
  ports+="$port""-""$(( $port + $(( $(( 1 << $(( 16 - $offset - $psidlen )) )) - 1 ))  ))"
  if [ $A -lt $Amax ]; then 
    if ! ((A % 3)); then ports="$ports"\\n; else ports="$ports ";fi
  fi
} 

# vars for bring up the map-e router
lp=$Amax
nxps=$(( 1 << $((16 - $offset)) ))
pslen=$(( 1 << $(( 16 - $offset - $psidlen )) ))
#echo -e "$ports"


if [ $(( ${hextet[3]} & 0xff )) != 0 ]; then
  echo "入力値とCEとで/64が異なる"
fi

hextet[3]=$((${hextet[3]} & 0xff00))
if $rfc; then
  hextet[4]=0
  hextet[5]=$(( $((  ${octet[0]} << 8  )) | ${octet[1]} ))
  hextet[6]=$(( $((  ${octet[2]} << 8  )) | ${octet[3]} ))
  hextet[7]=$psid
else
  hextet[4]=${octet[0]}
  hextet[5]=$(( $((${octet[1]} << 8)) | ${octet[2]} ))
  hextet[6]=$((${octet[3]} << 8))
  hextet[7]=$(($psid << 8))
fi

declare -a ce
for ((i=0; i < 4; i++)); do
  ce[i]=`printf %x ${hextet[$i]}`
done

ealen=$(( 56 - $ip6prefixlen ))
ip4prefixlen=$(( 32 - $(($ealen - $psidlen))  ))

declare -a hextet2
if [ $ip6prefixlen == 38 ]; then
  hextet2[0]=${hextet[0]}
  hextet2[1]=${hextet[1]}
  hextet2[2]=$(( ${hextet[2]} & 0xfc00))
elif [ $ip6prefixlen == 31 ]; then
  hextet2[0]=${hextet[0]}
  hextet2[1]=$(( ${hextet[1]} & 0xfffe ))
fi  

declare -a ip6prefix
for ((i=0; i < ${#hextet2[@]}; i++)); do
  ip6prefix[i]=`printf %x ${hextet2[$i]}` 
done 

prefix31_hex=`printf 0x%x $prefix31`
if   [[ $prefix31_hex -ge 0x24047a80 ]] && [[ $prefix31_hex -lt 0x24047a84 ]]; then
  peeraddr="2001:260:700:1::1:275"
elif [[ $prefix31_hex -ge 0x24047a84 ]] && [[ $prefix31_hex -lt 0x24047a88 ]]; then
  peeraddr="2001:260:700:1::1:276"
elif [[ $prefix31_hex -ge 0x240b0010 ]] && [[ $prefix31_hex -lt 0x240b0014 ]]; then
  peeraddr="2404:9200:225:100::64"
elif [[ $prefix31_hex -ge 0x240b0250 ]] && [[ $prefix31_hex -lt 0x240b0254 ]]; then
  peeraddr="2404:9200:225:100::64"
elif [ -n "${ruleprefix38_20[`printf 0x%x $prefix38`]}" ]; then
  peeraddr="2001:380:a120::9"
else
  peeraddr=""
fi

ipaddr=(${ipaddr//,/ })
ip4a="$(IFS="."; echo "${ipaddr[*]}")"
ip6pfx="$(IFS=":"; echo "${ip6prefix[*]}")" 
PFX=$new_ip6_prefix
CE="$(IFS=":"; echo "${ce[*]}")"
IPV4=${octet[0]}.${octet[1]}.${octet[2]}.${octet[3]}
PSID=$psid
BR=$peeraddr

sed -i -e "s/IPv4_IPv4/IPv4=${NET_ADDR}/g" /etc/mape_setup_rule.sh
sed -i -e "s/TUNDEV_TUNDEV/TUNDEV=${NET_L3D}/g" /etc/mape_setup_rule.sh
sed -i -e "s/PSID_PSID/PSID=${PSID}/g" /etc/mape_setup_rule.sh

cp /lib/netifd/proto/map.sh /lib/netifd/proto/map.sh.bak
sed -i "/ip4prefixlen=32/d" /lib/netifd/proto/map.sh
sed -i -e "s/mtu:-1280/mtu:-1460/g" /lib/netifd/proto/map.sh

sed -i "/exit 0/d" /etc/rc.local
echo "/etc/mape_setup_rule.sh" >> /etc/rc.local 
echo "exit 0" >> /etc/rc.local

echo -e "\033[0;36mIPV4: \033[0;39m"${NET_ADDR}
echo -e "\033[0;36mTUNDEV: \033[0;39m"${NET_L3D}
echo -e "\033[0;36mPSID: \033[0;39m"${PSID}
echo -e "\033[0;36mSTART UP: \033[0;33m"/etc/mape_setup_rule.sh
echo -e "\033[0;39m"
