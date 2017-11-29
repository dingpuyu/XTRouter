//
//  XTRouter.m
//  5i5jAPP
//
//  Created by 丁璞玉 on 2017/11/23.
//  Copyright © 2017年 NiLaisong. All rights reserved.
//

#import "XTRouter.h"
#import "NSString+URL.h"
#import <objc/runtime.h>

#define kSchema @"routerapp"
#define kRouterSetting @"XTRouterSetting.plist"
#define kPathOfMainBundle(x) [[NSBundle mainBundle] pathForResource:x ofType:@""]

@interface XTRouter()

@property (nonatomic,strong)NSDictionary* routerSettingDict;

@end

@implementation XTRouter

+ (instancetype)shareInstance{
    static XTRouter* router = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        router = [XTRouter new];
    });
    return router;
}

- (UIViewController *)controllerWithSchema:(NSString *)schema{
    
    //1.获取页面配置文件
    NSDictionary* pageSettingDict = [self settingDictWithSchema:schema];
    if (!pageSettingDict) {
        return nil;
    }
    //2.根据配置文件获取控制器
    UIViewController* vc = [self controllerWithSettingDict:pageSettingDict];

    return vc;
}

//获取对应控制器配置文件
- (NSDictionary*)settingDictWithSchema:(NSString*)schema{
    //routerapp://second/detail?url=klajflkajklf&name=adfjs
    if ([schema rangeOfString:[NSString stringWithFormat:@"%@://",kSchema]].location == NSNotFound) {
        return nil;
    }
    
    //取到路径和参数字符串
    NSArray* pathArray = [schema componentsSeparatedByString:[NSString stringWithFormat:@"%@://",kSchema]];
    if (pathArray.count != 2) {
        return nil;
    }
    //取出路径参数字符串
    NSString* pathParamString = [pathArray objectAtIndex:1];
    pathParamString = [pathParamString stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (pathParamString.length == 0) {
        return nil;
    }
    
    //根据问号分割出路径和参数字符串
    NSArray* pathParamArray = [pathParamString componentsSeparatedByString:@"?"];
    if (pathParamArray.count < 1) {
        return nil;
    }
    
    //路径字符串
    NSString* pathString = [pathParamArray objectAtIndex:0];
    pathString = [pathString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray* pathStringArray = [pathString componentsSeparatedByString:@"/"];
    if (pathStringArray.count != 2) {
        return nil;
    }
    
    //初步过滤，取出分类及页面类型参数字符串
    NSString* categoryString = [pathStringArray objectAtIndex:0];
    categoryString = [categoryString stringByReplacingOccurrencesOfString:@" " withString:@""];
    categoryString = [categoryString stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if (categoryString.length == 0) {
        return nil;
    }
    
    //获取页面名字
    NSString* pageName = [pathStringArray objectAtIndex:1];
    pageName = [pageName stringByReplacingOccurrencesOfString:@" " withString:@""];
    pageName = [pageName stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if (pageName.length == 0) {
        return nil;
    }
    
    //获取分类数据
    NSDictionary* categoryDic = [self.routerSettingDict objectForKey:categoryString];
    if (categoryDic == nil) {
        return nil;
    }
    
    //获取页面数据，如果参数没有值，直接返回，否则就去设置参数
    NSDictionary* pageDic = [categoryDic objectForKey:pageName];
    if (pageDic) {
        NSMutableDictionary* pageDictM = [NSMutableDictionary dictionaryWithDictionary:pageDic];
        NSMutableDictionary* paramDictM = [NSMutableDictionary dictionary];
        
        NSDictionary* defaultValueDict = [pageDic objectForKey:@"defaultValueDict"];
        if (defaultValueDict) {
            [paramDictM addEntriesFromDictionary:defaultValueDict];
        }
        
        if (pathParamArray.count > 1) {
            NSString* paramString = [pathParamArray objectAtIndex:1];
            NSDictionary* paramsMapDict = [pageDic objectForKey:@"paramsMapDict"];
            if (paramString.length > 0) {
                NSDictionary* paramDict = [self paramDictWith:paramString mapDict:paramsMapDict];
                for (NSString* keyString in paramDict.allKeys) {
                    NSString* value = [paramDict valueForKey:keyString];
                    value.length>0?[paramDictM setValue:value forKey:keyString]:nil;
                }
            }
        }
        
        [pageDictM setObject:paramDictM forKey:@"params"];
        
        return pageDictM;
    }
    return nil;
}
/*
- (NSDictionary*)settingDictWithSchema:(NSString*)schema{
    NSURL* schemaURL = [NSURL URLWithString:schema];
    if (schemaURL == nil) {
        return nil;
    }
    if ([schemaURL.scheme rangeOfString:@"routerapp"].location == NSNotFound) {
        return nil;
    }
    if ([schema rangeOfString:@"//"].location == NSNotFound) {
        return nil;
    }
    //初步过滤，取出分类及页面类型参数字符串
    NSString* categoryString = schemaURL.host;
    categoryString = [categoryString stringByReplacingOccurrencesOfString:@" " withString:@""];
    categoryString = [categoryString stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if (categoryString.length == 0) {
        return nil;
    }

    //获取页面名字
    NSString* pageName = schemaURL.path;
    pageName = [pageName stringByReplacingOccurrencesOfString:@" " withString:@""];
    pageName = [pageName stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if (pageName.length == 0) {
        return nil;
    }
    
    //获取页面参数
    NSString* paramString = schemaURL.query;
    paramString = [paramString stringByReplacingOccurrencesOfString:@" " withString:@""];
    paramString = [paramString stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    //获取分类数据
    NSDictionary* categoryDic = [self.routerSettingDict objectForKey:categoryString];
    if (categoryDic == nil) {
        return nil;
    }
    
    //获取页面数据，如果参数没有值，直接返回，否则就去设置参数
    NSDictionary* pageDic = [categoryDic objectForKey:pageName];
    if (pageDic) {
        NSMutableDictionary* pageDictM = [NSMutableDictionary dictionaryWithDictionary:pageDic];
        NSDictionary* paramsMapDict = [pageDic objectForKey:@"paramsMapDict"];
        if (paramString.length > 0) {
            NSDictionary* paramDict = [self paramDictWith:paramString mapDict:paramsMapDict];
            if (paramDict) {
                [pageDictM setObject:paramDict forKey:@"params"];
                return pageDictM;
            }
        }
        
    }
    
    return pageDic;
    
    return nil;
}*/

- (NSDictionary*)paramDictWith:(NSString*)paramString mapDict:(NSDictionary*)mapDict{
    paramString = [paramString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSArray* paramArray = [paramString componentsSeparatedByString:@"&"];
    if (paramArray == nil || paramArray.count == 0) {
        return nil;
    }
    
    NSMutableDictionary* paramDictM = [NSMutableDictionary dictionary];
    for (NSString* nameValue in paramArray) {
        NSString* nameValueString = [nameValue stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([nameValueString rangeOfString:@"="].location == NSNotFound) {
            continue;
        }
        NSArray* nameValueArray = [nameValueString componentsSeparatedByString:@"="];
        if (nameValueArray.count == 2) {
            NSString* key = [nameValueArray objectAtIndex:0];
            NSString* value = [nameValueArray objectAtIndex:1];
            NSString* mapKey = [mapDict objectForKey:key];
            key = mapKey.length>0?mapKey:key;
            if (value != nil && key != nil) {
                [paramDictM setValue:value forKey:key];
            }
        }
    }
    
    return paramDictM;
}

- (UIViewController*)controllerWithSettingDict:(NSDictionary*)settingDict{
    if (settingDict == nil) {
        return nil;
    }
    NSString* pageClassName = [settingDict objectForKey:@"pagename"];
    if (pageClassName.length == 0) {
        return nil;
    }
    
    Class vcClass = NSClassFromString(pageClassName);
    if (vcClass == nil) {
        return nil;
    }
    id object = [vcClass new];
    
    NSDictionary* paramDict = [settingDict objectForKey:@"params"];
    if (paramDict == nil || ![paramDict isKindOfClass:[NSDictionary class]]) {
        return object==nil?nil:object;
    }
    
    NSArray* vcPropertyNames = [self allPropertyNamesWithClass:vcClass];
    
    for (NSString* propertyName in vcPropertyNames) {
        id value = [paramDict valueForKey:propertyName];
        if (value) {
            [object setValue:value forKey:propertyName];
        }
    }
    
    return object;
}



- (NSDictionary *)routerSettingDict{
    if (!_routerSettingDict) {
        NSString* sPath = kPathOfMainBundle(kRouterSetting);
        _routerSettingDict = [NSDictionary dictionaryWithContentsOfFile:sPath];
    }
    return _routerSettingDict;
}


///通过运行时获取当前对象的所有属性的名称，以数组的形式返回
- (NSArray *)allPropertyNamesWithClass:(Class)class{
    ///存储所有的属性名称
    NSMutableArray *allNames = [[NSMutableArray alloc] init];
    
    ///存储属性的个数
    unsigned int propertyCount = 0;
    
    ///通过运行时获取当前类的属性
    objc_property_t *propertys = class_copyPropertyList(class, &propertyCount);
    
    //把属性放到数组中
    for (int i = 0; i < propertyCount; i ++) {
        ///取出第一个属性
        objc_property_t property = propertys[i];
        
        const char * propertyName = property_getName(property);
        
        [allNames addObject:[NSString stringWithUTF8String:propertyName]];
    }
    
    ///释放
    free(propertys);
    
    return allNames;
}

- (NSString*)handleSchemaHTMLPathWith:(NSURL*)webURL{
    if ([webURL.absoluteString rangeOfString:@"schema"].location == NSNotFound) {
        return [self handleHTMLPathWith:webURL];
    }
    NSString* query = webURL.query;
    if (query.length == 0) {
        return @"";
    }
    
    NSArray* paramArray = [query componentsSeparatedByString:@"&"];
    if (paramArray.count <= 0) {
        return @"";
    }
    
    NSString* schemaParam = @"";
    
    for (NSString* paramString in paramArray) {
        if ([paramString rangeOfString:@"schema"].location != NSNotFound) {
            schemaParam = paramString;
            break;
        }
    }
    
    if (schemaParam.length <= 0) {
        return @"";
    }
    
    NSArray* schemaArray = [schemaParam componentsSeparatedByString:@"="];
    if (schemaArray.count < 2) {
        return @"";
    }
    NSString* schemaEncodeString = [schemaArray objectAtIndex:1];
    if (schemaEncodeString.length <= 0) {
        return @"";
    }
    NSString* schemaDecodeString = [schemaEncodeString URLDecodedString];
    return schemaDecodeString;
}

- (NSString *)handleHTMLPathWith:(NSURL *)webURL{
    NSString* webURLString = webURL.absoluteString;
    if ([webURLString rangeOfString:kSchema].location == NSNotFound ) {
        return nil;
        //return [self handleHTMLPathWithURLAction:webURL];
    }
    
    NSArray* pathComponents = webURL.pathComponents;
    if (pathComponents.count < 4) {
        return @"";
    }
    NSString* key = [pathComponents objectAtIndex:1];
    if (![key isEqualToString:kSchema]) {
        return @"";
    }
    NSString* category = [pathComponents objectAtIndex:2];
    
    NSString* page = [pathComponents objectAtIndex:3];
    
    NSString* schema = [NSString stringWithFormat:@"%@://%@/%@?%@",kSchema,category,page,webURL.query];
    return schema;
}
/*
- (NSString*)handleHTMLPathWithURLAction:(NSURL*)webURL{
    NSString* webURLString = webURL.absoluteString;
    if ([webURLString rangeOfString:@"5i5j.com"].location == NSNotFound) {
        return @"";
    }
    
    NSArray* pathComponents = webURL.pathComponents;
    if (pathComponents.count < 4) {
        return @"";
    }
    NSString* cityDomain = [pathComponents objectAtIndex:1];
    NSString* cityId = @"1";
    NSString* category = @"";
    NSString* page = @"";
    NSString* code = @"";
    for (XTHomeSelectCityResultModel* resultModel in [HouseSearchOptions shareData].cityList) {
        if ([resultModel.domain isEqualToString:cityDomain]) {
            cityId = resultModel.code;
        }
    }
    NSDictionary* htmlPathMapDict = [self.routerSettingDict objectForKey:@"htmlPathMap"];
    if (htmlPathMapDict == nil) {
        return @"";
    }
    NSString* pageType = [pathComponents objectForIndex:2];
    
    if (pageType.length > 0) {
        NSDictionary* mapDict = [htmlPathMapDict objectForKey:pageType];
        if (mapDict) {
            category = [mapDict objectForKey:@"category"];
            page = [mapDict objectForKey:@"type"];
        }
    }
    
    NSString* pageName = [pathComponents objectForIndex:3];
    
    if (pageName.length > 0) {
        NSArray* pageNameArray = [pageName componentsSeparatedByString:@"."];
        if (pageNameArray.count > 1) {
            code = [pageNameArray objectForIndex:0];
        }
    }
    
    NSString* schema = [NSString stringWithFormat:@"routerapp://%@/%@?cityid=%@&code=%@",category,page,cityId,code];

    return schema;
}*/

@end
