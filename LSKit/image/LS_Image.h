//
//  iOS_Image.h
//  iOS_Image
//
//  Created by SMCB on 2018/2/8.
//

#import "LSImageResourceServer.h"

#ifndef LS_IMAGE
/* 带缓存 imageName:*/
#define LS_IMAGE(name) [LSImageResourceServer imageName:(name) file:__FILE__]
#endif

#define LS_IMAGE_Module(name,module) [LSImageResourceServer imageName:name moduleName:module file:__FILE__]


/* 不带缓存 imageWithContentsOfFile: */
#ifndef LS_IMAGE_CONTENT
#define LS_IMAGE_CONTENT(name) [LSImageResourceServer imageWithContentsOfFileName:(name)]
#endif

