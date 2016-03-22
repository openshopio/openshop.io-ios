//
//  BFParsedResult.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFParsedResult.h"
#import "PersistentStorage.h"
#import "BFCategory.h"
#import "NSObject+BFRuntimeAdditions.h"

/**
 * Data model properties storage instance variable identification.
 */
static const char *dataModelPropertiesInstanceVariableName = "_dataModelProperties";
/**
 * Parsed result association key identifying registered data model classes.
 */
static char *const BFParsedResultRegisteredDataModelClassesAssociationKey = "BFParsedResult_registeredDataModelClasses";


@interface BFParsedResult ()

/**
 * Internal storage for data model properties values.
 */
@property (nonatomic, strong) NSMutableDictionary *dataModelProperties;

@end



@implementation BFParsedResult


#pragma mark - Initialization

- (id)init {
    self = [super init];
    if (self) {
        self.dataModelProperties = [NSMutableDictionary new];
    }
    return self;
}

+ (void)setupDataModelClass:(Class <BFAPIResponseDataModelMapping>)dataModelClass {
    NSMutableSet *classes = [self BFN_getAssociatedObjectForKey:BFParsedResultRegisteredDataModelClassesAssociationKey withDefaultValue:[NSMutableSet new]];
    if(![classes containsObject:dataModelClass]) {
        // data model properties
        [self addDataModelProperties:dataModelClass];
        // associate registered data model class
        [classes addObject:dataModelClass];
        [self BFN_setAssociatedObject:classes forKey:BFParsedResultRegisteredDataModelClassesAssociationKey];
    }
}

+ (Class <BFAPIResponseDataModelMapping>)dataModelClass {
    // should be implemented by the subclass
    return nil;
}


#pragma mark - BFDataModelResponseParserMapping

+ (id)dataModelFromDictionary:(NSDictionary *)dictionary {
    // data model setup
    [self setupDataModelClass:[self dataModelClass]];
    
    // parse JSON dictionary
    NSError *error;
    id dataObject = [MTLJSONAdapter modelOfClass:self.class fromJSONDictionary:dictionary error:&error];
    
    // return data model instance
    return !error ? [dataObject dataModelInstance] : nil;
}

- (id)dataModelInstance {
    Class dataModelClass = [[self class] dataModelClass];
    id dataModel;
    
    // init new data model class in managed object context
    if([dataModelClass isSubclassOfClass:[BFRecord class]]) {
        dataModel = [NSEntityDescription insertNewObjectForEntityForName:[dataModelClass entityName] inManagedObjectContext:[[StorageManager defaultManager] privateQueueContext]];
    }
    // init new data model
    else {
        dataModel = [dataModelClass new];
    }
    
    [self.dataModelProperties enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (obj != [NSNull null] && [dataModel respondsToSelector:NSSelectorFromString(key)]) {
            [dataModel setValue:obj forKey:key];
        }
    }];
    return dataModel;
}


#pragma mark - JSON Serialization

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [[self dataModelClass] JSONKeyPathsByPropertyKey];
}


#pragma mark - Data Model Properties

+ (NSArray *)dataModelProperties:(Class)dataModel {
    // properties count
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList(dataModel, &outCount);
    
    NSMutableArray *dataModelProperties = [NSMutableArray new];
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        [dataModelProperties addObject:[NSValue valueWithPointer:property]];
    }
    
    // free up memory
    free(properties);
    return dataModelProperties;
}

+ (void)addDataModelProperties:(Class)dataModel {
    NSArray *properties = [self dataModelProperties:dataModel];
    for (int i = 0; i < properties.count; i++) {
        // data model property
        objc_property_t property = (objc_property_t)[[properties objectAtIndex:i]pointerValue];
        unsigned int propertyAttributesCount;
        objc_property_attribute_t *propertyAttributes = property_copyAttributeList(property, &propertyAttributesCount);
        
        // add retrieved property
        if(class_addProperty(self, property_getName(property), propertyAttributes, propertyAttributesCount)) {
            NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSASCIIStringEncoding];
            
            // property getter
            [self addDataModelPropertyGetter:propertyName];
            // property setter
            [self addDataModelPropertySetter:propertyName];
        }
        else {
            // replace property if already exists
            class_replaceProperty(self, property_getName(property), propertyAttributes, propertyAttributesCount);
        }
    }
}

+ (void)addDataModelPropertyGetter:(NSString *)propertyName {
    class_addMethod([self class], NSSelectorFromString(propertyName), (IMP)propertyGetter, "@@:");
}

+ (void)addDataModelPropertySetter:(NSString *)propertyName {
    // build a setter name
    NSMutableString *propertySetterName = [NSMutableString stringWithString:@"set"];
    // first capital letter
    [propertySetterName appendString:[[propertyName substringToIndex:1] uppercaseString]];
    // rest of the property name characters
    if ([propertyName length] > 1) {
        [propertySetterName appendString:[propertyName substringFromIndex:1]];
    }
    // append setter parameter
    [propertySetterName appendString:@":"];
    
    class_addMethod([self class], NSSelectorFromString(propertySetterName), (IMP)propertySetter, "v@:@");
}


#pragma mark - Data Model Property Setter & Getter

void propertySetter(id self, SEL _cmd, id newPropertyValue) {
    Ivar ivar = class_getInstanceVariable([BFParsedResult class], dataModelPropertiesInstanceVariableName);
    NSMutableDictionary *dataModelProperties = (NSMutableDictionary *)object_getIvar(self, ivar);
    
    if(dataModelProperties) {
        // build a property name
        NSArray *propertySetterComponents = [NSStringFromSelector(_cmd) componentsSeparatedByString:@"set"];
        if([propertySetterComponents count] == 2) {
            NSString *propertySetterComponent = [propertySetterComponents lastObject];
            
            NSMutableString *propertyName = [NSMutableString new];
            // first character
            [propertyName appendString:[[propertySetterComponent substringToIndex:1] lowercaseString]];
            // remove parameter character ":"
            [propertyName appendString:[propertySetterComponent substringWithRange:NSMakeRange(1, propertySetterComponent.length-2)]];
            
            // save nil value
            if(!newPropertyValue) {
                newPropertyValue = [NSNull null];
            }
            
            // save property value
            [dataModelProperties setObject:[newPropertyValue copy] forKey:propertyName];
            object_setIvar(self, ivar, dataModelProperties);
        }
    }
}

id propertyGetter(id self, SEL _cmd) {
    Ivar ivar = class_getInstanceVariable([BFParsedResult class], dataModelPropertiesInstanceVariableName);
    NSMutableDictionary *dataModelProperties = (NSMutableDictionary *)object_getIvar(self, ivar);
    // property name building
    NSString *propertyName = NSStringFromSelector(_cmd);
    return dataModelProperties ? [dataModelProperties objectForKey:propertyName] : nil;
}


@end



