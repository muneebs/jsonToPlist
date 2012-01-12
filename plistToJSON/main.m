//
//  main.m
//  plistToJSON
//
//  Created by Craig Spitzkoff on 1/11/12.
//  Copyright (c) 2012 Raizlabs Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

int main (int argc, const char * argv[])
{

    @autoreleasepool {
        
        if(argc < 2)
        {
            printf("Not enough arguments; missing plist file.\n");
            return 1;
        }
        
        NSFileManager *filemgr;
        NSString *currentpath;
        
        filemgr = [[NSFileManager alloc] init];
        
        currentpath = [filemgr currentDirectoryPath];
        
        // try to find the full path to the spcified file.
        NSString* path = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
        if(![filemgr fileExistsAtPath:path])
        {
            // path was not absolute or did not exist. Try looking in the current path. 
            path = [currentpath stringByAppendingPathComponent:path];
            
            if(![filemgr fileExistsAtPath:path])
            {
                printf("Could not find file %s\n", argv[1]);
                return 1;
            }
        }
        
        
        NSDictionary* dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
        if (nil == dictionary) {
            printf("Could not parse plist file %s\n", argv[1]);
            return 1;
        }
        
        
        NSError* error = nil;
        
        NSData* data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
        
        if(nil == data)
        {
            NSString* errorMessage = [NSString stringWithFormat:@"There was an error converting to JSON: %@", error];
            printf("%s", [errorMessage cStringUsingEncoding:NSUTF8StringEncoding]);
            return 1;
        }
        
        path = [path stringByAppendingPathExtension:@"json"];
        
        if (![data writeToFile:path atomically:YES]) {
            printf("Error writing to file: %s", [path cStringUsingEncoding:NSUTF8StringEncoding]);
            return 1;
        }
        
    }
    return 0;
}

