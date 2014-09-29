#import "OCRWebServiceSvc.h"
#import <libxml/xmlstring.h>
#if TARGET_OS_IPHONE
#import <CFNetwork/CFNetwork.h>
#endif
#ifndef ADVANCED_AUTHENTICATION
#define ADVANCED_AUTHENTICATION 0
#endif
#if ADVANCED_AUTHENTICATION && TARGET_OS_IPHONE
#import <Security/Security.h>
#endif
@implementation OCRWebServiceSvc_OCRWSInputImage
@synthesize soapSigner;
- (id)init
{
	if((self = [super init])) {
		fileName = 0;
		fileData = 0;
	}
	
	return self;
}
- (void)dealloc
{
	[soapSigner release];
	if(fileName != nil) [fileName release];
	if(fileData != nil) [fileData release];
	
	[super dealloc];
}
- (NSString *)nsPrefix
{
	return @"OCRWebServiceSvc";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
	NSString *nodeName = nil;
	if(elNSPrefix != nil && [elNSPrefix length] > 0)
	{
		nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
	}
	else
	{
		nodeName = [NSString stringWithFormat:@"%@:%@", @"OCRWebServiceSvc", elName];
	}
	xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
	
	[self addAttributesToNode:node];
	
	[self addElementsToNode:node];
	
	return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
	
}
- (void)addElementsToNode:(xmlNodePtr)node
{
	
	if(self.fileName != 0) {
		xmlAddChild(node, [self.fileName xmlNodeForDoc:node->doc elementName:@"fileName" elementNSPrefix:@"OCRWebServiceSvc"]);
	}
	if(self.fileData != 0) {
		xmlAddChild(node, [self.fileData xmlNodeForDoc:node->doc elementName:@"fileData" elementNSPrefix:@"OCRWebServiceSvc"]);
	}
}
/* elements */
@synthesize fileName;
@synthesize fileData;
/* attributes */
- (NSDictionary *)attributes
{
	NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
	
	return attributes;
}
+ (OCRWebServiceSvc_OCRWSInputImage *)deserializeNode:(xmlNodePtr)cur
{
	OCRWebServiceSvc_OCRWSInputImage *newObject = [[OCRWebServiceSvc_OCRWSInputImage new] autorelease];
	
	[newObject deserializeAttributesFromNode:cur];
	[newObject deserializeElementsFromNode:cur];
	
	return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
	
	
	for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
		if(cur->type == XML_ELEMENT_NODE) {
			xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
			NSString *elementString = nil;
			
			if(elementText != NULL) {
				elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
				[elementString self]; // avoid compiler warning for unused var
				xmlFree(elementText);
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "fileName")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [NSString class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				self.fileName = newChild;
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "fileData")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [NSData class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				self.fileData = newChild;
			}
		}
	}
}
/* NSCoder functions taken from: 
 * http://davedelong.com/blog/2009/04/13/aspect-oriented-programming-objective-c
 */
- (id) initWithCoder:(NSCoder *)decoder {
	if ([super respondsToSelector:@selector(initWithCoder:)] && ![self isKindOfClass:[super class]]) {
		self = [super performSelector:@selector(initWithCoder:) withObject:decoder];
	} else {
		self = [super init];
	}
	if (self == nil) { return nil; }
 
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	unsigned int numIvars = 0;
	Ivar * ivars = class_copyIvarList([self class], &numIvars);
	for(int i = 0; i < numIvars; i++) {
		Ivar thisIvar = ivars[i];
		NSString * key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
		id value = [decoder decodeObjectForKey:key];
		if (value == nil) { value = [NSNumber numberWithFloat:0.0]; }
		[self setValue:value forKey:key];
	}
	if (numIvars > 0) { free(ivars); }
	[pool drain];
	return self;
}
- (void) encodeWithCoder:(NSCoder *)encoder {
	if ([super respondsToSelector:@selector(encodeWithCoder:)] && ![self isKindOfClass:[super class]]) {
		[super performSelector:@selector(encodeWithCoder:) withObject:encoder];
	}
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	unsigned int numIvars = 0;
	Ivar * ivars = class_copyIvarList([self class], &numIvars);
	for (int i = 0; i < numIvars; i++) {
		Ivar thisIvar = ivars[i];
		NSString * key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
		id value = [self valueForKey:key];
		[encoder encodeObject:value forKey:key];
	}
	if (numIvars > 0) { free(ivars); }
	[pool drain];
}
@end
OCRWebServiceSvc_OCRWS_Language OCRWebServiceSvc_OCRWS_Language_enumFromString(NSString *string)
{
	if([string isEqualToString:@"BRAZILIAN"]) {
		return OCRWebServiceSvc_OCRWS_Language_BRAZILIAN;
	}
	if([string isEqualToString:@"BYELORUSSIAN"]) {
		return OCRWebServiceSvc_OCRWS_Language_BYELORUSSIAN;
	}
	if([string isEqualToString:@"BULGARIAN"]) {
		return OCRWebServiceSvc_OCRWS_Language_BULGARIAN;
	}
	if([string isEqualToString:@"CATALAN"]) {
		return OCRWebServiceSvc_OCRWS_Language_CATALAN;
	}
	if([string isEqualToString:@"CROATIAN"]) {
		return OCRWebServiceSvc_OCRWS_Language_CROATIAN;
	}
	if([string isEqualToString:@"CZECH"]) {
		return OCRWebServiceSvc_OCRWS_Language_CZECH;
	}
	if([string isEqualToString:@"DANISH"]) {
		return OCRWebServiceSvc_OCRWS_Language_DANISH;
	}
	if([string isEqualToString:@"DUTCH"]) {
		return OCRWebServiceSvc_OCRWS_Language_DUTCH;
	}
	if([string isEqualToString:@"ENGLISH"]) {
		return OCRWebServiceSvc_OCRWS_Language_ENGLISH;
	}
	if([string isEqualToString:@"ESTONIAN"]) {
		return OCRWebServiceSvc_OCRWS_Language_ESTONIAN;
	}
	if([string isEqualToString:@"FINNISH"]) {
		return OCRWebServiceSvc_OCRWS_Language_FINNISH;
	}
	if([string isEqualToString:@"FRENCH"]) {
		return OCRWebServiceSvc_OCRWS_Language_FRENCH;
	}
	if([string isEqualToString:@"GERMAN"]) {
		return OCRWebServiceSvc_OCRWS_Language_GERMAN;
	}
	if([string isEqualToString:@"GREEK"]) {
		return OCRWebServiceSvc_OCRWS_Language_GREEK;
	}
	if([string isEqualToString:@"HUNGARIAN"]) {
		return OCRWebServiceSvc_OCRWS_Language_HUNGARIAN;
	}
	if([string isEqualToString:@"INDONESIAN"]) {
		return OCRWebServiceSvc_OCRWS_Language_INDONESIAN;
	}
	if([string isEqualToString:@"ITALIAN"]) {
		return OCRWebServiceSvc_OCRWS_Language_ITALIAN;
	}
	if([string isEqualToString:@"LATIN"]) {
		return OCRWebServiceSvc_OCRWS_Language_LATIN;
	}
	if([string isEqualToString:@"LATVIAN"]) {
		return OCRWebServiceSvc_OCRWS_Language_LATVIAN;
	}
	if([string isEqualToString:@"LITHUANIAN"]) {
		return OCRWebServiceSvc_OCRWS_Language_LITHUANIAN;
	}
	if([string isEqualToString:@"MOLDAVIAN"]) {
		return OCRWebServiceSvc_OCRWS_Language_MOLDAVIAN;
	}
	if([string isEqualToString:@"POLISH"]) {
		return OCRWebServiceSvc_OCRWS_Language_POLISH;
	}
	if([string isEqualToString:@"PORTUGUESE"]) {
		return OCRWebServiceSvc_OCRWS_Language_PORTUGUESE;
	}
	if([string isEqualToString:@"ROMANIAN"]) {
		return OCRWebServiceSvc_OCRWS_Language_ROMANIAN;
	}
	if([string isEqualToString:@"RUSSIAN"]) {
		return OCRWebServiceSvc_OCRWS_Language_RUSSIAN;
	}
	if([string isEqualToString:@"SERBIAN"]) {
		return OCRWebServiceSvc_OCRWS_Language_SERBIAN;
	}
	if([string isEqualToString:@"SLOVAKIAN"]) {
		return OCRWebServiceSvc_OCRWS_Language_SLOVAKIAN;
	}
	if([string isEqualToString:@"SLOVENIAN"]) {
		return OCRWebServiceSvc_OCRWS_Language_SLOVENIAN;
	}
	if([string isEqualToString:@"SPANISH"]) {
		return OCRWebServiceSvc_OCRWS_Language_SPANISH;
	}
	if([string isEqualToString:@"SWEDISH"]) {
		return OCRWebServiceSvc_OCRWS_Language_SWEDISH;
	}
	if([string isEqualToString:@"TURKISH"]) {
		return OCRWebServiceSvc_OCRWS_Language_TURKISH;
	}
	if([string isEqualToString:@"UKRAINIAN"]) {
		return OCRWebServiceSvc_OCRWS_Language_UKRAINIAN;
	}
	if([string isEqualToString:@"JAPANESE"]) {
		return OCRWebServiceSvc_OCRWS_Language_JAPANESE;
	}
	if([string isEqualToString:@"CHINESESIMPLIFIED"]) {
		return OCRWebServiceSvc_OCRWS_Language_CHINESESIMPLIFIED;
	}
	if([string isEqualToString:@"CHINESETRADITIONAL"]) {
		return OCRWebServiceSvc_OCRWS_Language_CHINESETRADITIONAL;
	}
	if([string isEqualToString:@"KOREAN"]) {
		return OCRWebServiceSvc_OCRWS_Language_KOREAN;
	}
	
	return OCRWebServiceSvc_OCRWS_Language_none;
}
NSString * OCRWebServiceSvc_OCRWS_Language_stringFromEnum(OCRWebServiceSvc_OCRWS_Language enumValue)
{
	switch (enumValue) {
		case OCRWebServiceSvc_OCRWS_Language_BRAZILIAN:
			return @"BRAZILIAN";
			break;
		case OCRWebServiceSvc_OCRWS_Language_BYELORUSSIAN:
			return @"BYELORUSSIAN";
			break;
		case OCRWebServiceSvc_OCRWS_Language_BULGARIAN:
			return @"BULGARIAN";
			break;
		case OCRWebServiceSvc_OCRWS_Language_CATALAN:
			return @"CATALAN";
			break;
		case OCRWebServiceSvc_OCRWS_Language_CROATIAN:
			return @"CROATIAN";
			break;
		case OCRWebServiceSvc_OCRWS_Language_CZECH:
			return @"CZECH";
			break;
		case OCRWebServiceSvc_OCRWS_Language_DANISH:
			return @"DANISH";
			break;
		case OCRWebServiceSvc_OCRWS_Language_DUTCH:
			return @"DUTCH";
			break;
		case OCRWebServiceSvc_OCRWS_Language_ENGLISH:
			return @"ENGLISH";
			break;
		case OCRWebServiceSvc_OCRWS_Language_ESTONIAN:
			return @"ESTONIAN";
			break;
		case OCRWebServiceSvc_OCRWS_Language_FINNISH:
			return @"FINNISH";
			break;
		case OCRWebServiceSvc_OCRWS_Language_FRENCH:
			return @"FRENCH";
			break;
		case OCRWebServiceSvc_OCRWS_Language_GERMAN:
			return @"GERMAN";
			break;
		case OCRWebServiceSvc_OCRWS_Language_GREEK:
			return @"GREEK";
			break;
		case OCRWebServiceSvc_OCRWS_Language_HUNGARIAN:
			return @"HUNGARIAN";
			break;
		case OCRWebServiceSvc_OCRWS_Language_INDONESIAN:
			return @"INDONESIAN";
			break;
		case OCRWebServiceSvc_OCRWS_Language_ITALIAN:
			return @"ITALIAN";
			break;
		case OCRWebServiceSvc_OCRWS_Language_LATIN:
			return @"LATIN";
			break;
		case OCRWebServiceSvc_OCRWS_Language_LATVIAN:
			return @"LATVIAN";
			break;
		case OCRWebServiceSvc_OCRWS_Language_LITHUANIAN:
			return @"LITHUANIAN";
			break;
		case OCRWebServiceSvc_OCRWS_Language_MOLDAVIAN:
			return @"MOLDAVIAN";
			break;
		case OCRWebServiceSvc_OCRWS_Language_POLISH:
			return @"POLISH";
			break;
		case OCRWebServiceSvc_OCRWS_Language_PORTUGUESE:
			return @"PORTUGUESE";
			break;
		case OCRWebServiceSvc_OCRWS_Language_ROMANIAN:
			return @"ROMANIAN";
			break;
		case OCRWebServiceSvc_OCRWS_Language_RUSSIAN:
			return @"RUSSIAN";
			break;
		case OCRWebServiceSvc_OCRWS_Language_SERBIAN:
			return @"SERBIAN";
			break;
		case OCRWebServiceSvc_OCRWS_Language_SLOVAKIAN:
			return @"SLOVAKIAN";
			break;
		case OCRWebServiceSvc_OCRWS_Language_SLOVENIAN:
			return @"SLOVENIAN";
			break;
		case OCRWebServiceSvc_OCRWS_Language_SPANISH:
			return @"SPANISH";
			break;
		case OCRWebServiceSvc_OCRWS_Language_SWEDISH:
			return @"SWEDISH";
			break;
		case OCRWebServiceSvc_OCRWS_Language_TURKISH:
			return @"TURKISH";
			break;
		case OCRWebServiceSvc_OCRWS_Language_UKRAINIAN:
			return @"UKRAINIAN";
			break;
		case OCRWebServiceSvc_OCRWS_Language_JAPANESE:
			return @"JAPANESE";
			break;
		case OCRWebServiceSvc_OCRWS_Language_CHINESESIMPLIFIED:
			return @"CHINESESIMPLIFIED";
			break;
		case OCRWebServiceSvc_OCRWS_Language_CHINESETRADITIONAL:
			return @"CHINESETRADITIONAL";
			break;
		case OCRWebServiceSvc_OCRWS_Language_KOREAN:
			return @"KOREAN";
			break;
		default:
			return @"";
	}
}
OCRWebServiceSvc_OCRWS_OutputFormat OCRWebServiceSvc_OCRWS_OutputFormat_enumFromString(NSString *string)
{
	if([string isEqualToString:@"DOC"]) {
		return OCRWebServiceSvc_OCRWS_OutputFormat_DOC;
	}
	if([string isEqualToString:@"PDF"]) {
		return OCRWebServiceSvc_OCRWS_OutputFormat_PDF;
	}
	if([string isEqualToString:@"EXCEL"]) {
		return OCRWebServiceSvc_OCRWS_OutputFormat_EXCEL;
	}
	if([string isEqualToString:@"HTML"]) {
		return OCRWebServiceSvc_OCRWS_OutputFormat_HTML;
	}
	if([string isEqualToString:@"TXT"]) {
		return OCRWebServiceSvc_OCRWS_OutputFormat_TXT;
	}
	if([string isEqualToString:@"RTF"]) {
		return OCRWebServiceSvc_OCRWS_OutputFormat_RTF;
	}
	if([string isEqualToString:@"PDFIMGTEXT"]) {
		return OCRWebServiceSvc_OCRWS_OutputFormat_PDFIMGTEXT;
	}
	
	return OCRWebServiceSvc_OCRWS_OutputFormat_none;
}
NSString * OCRWebServiceSvc_OCRWS_OutputFormat_stringFromEnum(OCRWebServiceSvc_OCRWS_OutputFormat enumValue)
{
	switch (enumValue) {
		case OCRWebServiceSvc_OCRWS_OutputFormat_DOC:
			return @"DOC";
			break;
		case OCRWebServiceSvc_OCRWS_OutputFormat_PDF:
			return @"PDF";
			break;
		case OCRWebServiceSvc_OCRWS_OutputFormat_EXCEL:
			return @"EXCEL";
			break;
		case OCRWebServiceSvc_OCRWS_OutputFormat_HTML:
			return @"HTML";
			break;
		case OCRWebServiceSvc_OCRWS_OutputFormat_TXT:
			return @"TXT";
			break;
		case OCRWebServiceSvc_OCRWS_OutputFormat_RTF:
			return @"RTF";
			break;
		case OCRWebServiceSvc_OCRWS_OutputFormat_PDFIMGTEXT:
			return @"PDFIMGTEXT";
			break;
		default:
			return @"";
	}
}
@implementation OCRWebServiceSvc_OCRWSZone
@synthesize soapSigner;
- (id)init
{
	if((self = [super init])) {
		Top = 0;
		Left = 0;
		Height = 0;
		Width = 0;
		ZoneType = 0;
	}
	
	return self;
}
- (void)dealloc
{
	[soapSigner release];
	if(Top != nil) [Top release];
	if(Left != nil) [Left release];
	if(Height != nil) [Height release];
	if(Width != nil) [Width release];
	if(ZoneType != nil) [ZoneType release];
	
	[super dealloc];
}
- (NSString *)nsPrefix
{
	return @"OCRWebServiceSvc";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
	NSString *nodeName = nil;
	if(elNSPrefix != nil && [elNSPrefix length] > 0)
	{
		nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
	}
	else
	{
		nodeName = [NSString stringWithFormat:@"%@:%@", @"OCRWebServiceSvc", elName];
	}
	xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
	
	[self addAttributesToNode:node];
	
	[self addElementsToNode:node];
	
	return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
	
}
- (void)addElementsToNode:(xmlNodePtr)node
{
	
	if(self.Top != 0) {
		xmlAddChild(node, [self.Top xmlNodeForDoc:node->doc elementName:@"Top" elementNSPrefix:@"OCRWebServiceSvc"]);
	}
	if(self.Left != 0) {
		xmlAddChild(node, [self.Left xmlNodeForDoc:node->doc elementName:@"Left" elementNSPrefix:@"OCRWebServiceSvc"]);
	}
	if(self.Height != 0) {
		xmlAddChild(node, [self.Height xmlNodeForDoc:node->doc elementName:@"Height" elementNSPrefix:@"OCRWebServiceSvc"]);
	}
	if(self.Width != 0) {
		xmlAddChild(node, [self.Width xmlNodeForDoc:node->doc elementName:@"Width" elementNSPrefix:@"OCRWebServiceSvc"]);
	}
	if(self.ZoneType != 0) {
		xmlAddChild(node, [self.ZoneType xmlNodeForDoc:node->doc elementName:@"ZoneType" elementNSPrefix:@"OCRWebServiceSvc"]);
	}
}
/* elements */
@synthesize Top;
@synthesize Left;
@synthesize Height;
@synthesize Width;
@synthesize ZoneType;
/* attributes */
- (NSDictionary *)attributes
{
	NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
	
	return attributes;
}
+ (OCRWebServiceSvc_OCRWSZone *)deserializeNode:(xmlNodePtr)cur
{
	OCRWebServiceSvc_OCRWSZone *newObject = [[OCRWebServiceSvc_OCRWSZone new] autorelease];
	
	[newObject deserializeAttributesFromNode:cur];
	[newObject deserializeElementsFromNode:cur];
	
	return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
	
	
	for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
		if(cur->type == XML_ELEMENT_NODE) {
			xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
			NSString *elementString = nil;
			
			if(elementText != NULL) {
				elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
				[elementString self]; // avoid compiler warning for unused var
				xmlFree(elementText);
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "Top")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [NSNumber class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				self.Top = newChild;
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "Left")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [NSNumber class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				self.Left = newChild;
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "Height")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [NSNumber class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				self.Height = newChild;
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "Width")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [NSNumber class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				self.Width = newChild;
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "ZoneType")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [NSNumber class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				self.ZoneType = newChild;
			}
		}
	}
}
/* NSCoder functions taken from: 
 * http://davedelong.com/blog/2009/04/13/aspect-oriented-programming-objective-c
 */
- (id) initWithCoder:(NSCoder *)decoder {
	if ([super respondsToSelector:@selector(initWithCoder:)] && ![self isKindOfClass:[super class]]) {
		self = [super performSelector:@selector(initWithCoder:) withObject:decoder];
	} else {
		self = [super init];
	}
	if (self == nil) { return nil; }
 
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	unsigned int numIvars = 0;
	Ivar * ivars = class_copyIvarList([self class], &numIvars);
	for(int i = 0; i < numIvars; i++) {
		Ivar thisIvar = ivars[i];
		NSString * key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
		id value = [decoder decodeObjectForKey:key];
		if (value == nil) { value = [NSNumber numberWithFloat:0.0]; }
		[self setValue:value forKey:key];
	}
	if (numIvars > 0) { free(ivars); }
	[pool drain];
	return self;
}
- (void) encodeWithCoder:(NSCoder *)encoder {
	if ([super respondsToSelector:@selector(encodeWithCoder:)] && ![self isKindOfClass:[super class]]) {
		[super performSelector:@selector(encodeWithCoder:) withObject:encoder];
	}
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	unsigned int numIvars = 0;
	Ivar * ivars = class_copyIvarList([self class], &numIvars);
	for (int i = 0; i < numIvars; i++) {
		Ivar thisIvar = ivars[i];
		NSString * key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
		id value = [self valueForKey:key];
		[encoder encodeObject:value forKey:key];
	}
	if (numIvars > 0) { free(ivars); }
	[pool drain];
}
@end
@implementation OCRWebServiceSvc_ArrayOfOCRWSZone
@synthesize soapSigner;
- (id)init
{
	if((self = [super init])) {
		OCRWSZone = [[NSMutableArray alloc] init];
	}
	
	return self;
}
- (void)dealloc
{
	[soapSigner release];
	if(OCRWSZone != nil) [OCRWSZone release];
	
	[super dealloc];
}
- (NSString *)nsPrefix
{
	return @"OCRWebServiceSvc";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
	NSString *nodeName = nil;
	if(elNSPrefix != nil && [elNSPrefix length] > 0)
	{
		nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
	}
	else
	{
		nodeName = [NSString stringWithFormat:@"%@:%@", @"OCRWebServiceSvc", elName];
	}
	xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
	
	[self addAttributesToNode:node];
	
	[self addElementsToNode:node];
	
	return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
	
}
- (void)addElementsToNode:(xmlNodePtr)node
{
	
	if(self.OCRWSZone != 0) {
		for(OCRWebServiceSvc_OCRWSZone * child in self.OCRWSZone) {
			xmlAddChild(node, [child xmlNodeForDoc:node->doc elementName:@"OCRWSZone" elementNSPrefix:@"OCRWebServiceSvc"]);
		}
	}
}
/* elements */
@synthesize OCRWSZone;
- (void)addOCRWSZone:(OCRWebServiceSvc_OCRWSZone *)toAdd
{
	if(toAdd != nil) [OCRWSZone addObject:toAdd];
}
/* attributes */
- (NSDictionary *)attributes
{
	NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
	
	return attributes;
}
+ (OCRWebServiceSvc_ArrayOfOCRWSZone *)deserializeNode:(xmlNodePtr)cur
{
	OCRWebServiceSvc_ArrayOfOCRWSZone *newObject = [[OCRWebServiceSvc_ArrayOfOCRWSZone new] autorelease];
	
	[newObject deserializeAttributesFromNode:cur];
	[newObject deserializeElementsFromNode:cur];
	
	return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
	
	
	for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
		if(cur->type == XML_ELEMENT_NODE) {
			xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
			NSString *elementString = nil;
			
			if(elementText != NULL) {
				elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
				[elementString self]; // avoid compiler warning for unused var
				xmlFree(elementText);
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "OCRWSZone")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [OCRWebServiceSvc_OCRWSZone class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				if(newChild != nil) [self.OCRWSZone addObject:newChild];
			}
		}
	}
}
/* NSCoder functions taken from: 
 * http://davedelong.com/blog/2009/04/13/aspect-oriented-programming-objective-c
 */
- (id) initWithCoder:(NSCoder *)decoder {
	if ([super respondsToSelector:@selector(initWithCoder:)] && ![self isKindOfClass:[super class]]) {
		self = [super performSelector:@selector(initWithCoder:) withObject:decoder];
	} else {
		self = [super init];
	}
	if (self == nil) { return nil; }
 
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	unsigned int numIvars = 0;
	Ivar * ivars = class_copyIvarList([self class], &numIvars);
	for(int i = 0; i < numIvars; i++) {
		Ivar thisIvar = ivars[i];
		NSString * key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
		id value = [decoder decodeObjectForKey:key];
		if (value == nil) { value = [NSNumber numberWithFloat:0.0]; }
		[self setValue:value forKey:key];
	}
	if (numIvars > 0) { free(ivars); }
	[pool drain];
	return self;
}
- (void) encodeWithCoder:(NSCoder *)encoder {
	if ([super respondsToSelector:@selector(encodeWithCoder:)] && ![self isKindOfClass:[super class]]) {
		[super performSelector:@selector(encodeWithCoder:) withObject:encoder];
	}
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	unsigned int numIvars = 0;
	Ivar * ivars = class_copyIvarList([self class], &numIvars);
	for (int i = 0; i < numIvars; i++) {
		Ivar thisIvar = ivars[i];
		NSString * key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
		id value = [self valueForKey:key];
		[encoder encodeObject:value forKey:key];
	}
	if (numIvars > 0) { free(ivars); }
	[pool drain];
}
@end
@implementation OCRWebServiceSvc_OCRWSSettings
@synthesize soapSigner;
- (id)init
{
	if((self = [super init])) {
		ocrLanguages = [[NSMutableArray alloc] init];
		outputDocumentFormat = 0;
		convertToBW = 0;
		getOCRText = 0;
		createOutputDocument = 0;
		multiPageDoc = 0;
		pageNumbers = 0;
		ocrZones = 0;
		ocrWords = 0;
	}
	
	return self;
}
- (void)dealloc
{
	[soapSigner release];
	if(convertToBW != nil) [convertToBW release];
	if(getOCRText != nil) [getOCRText release];
	if(createOutputDocument != nil) [createOutputDocument release];
	if(multiPageDoc != nil) [multiPageDoc release];
	if(pageNumbers != nil) [pageNumbers release];
	if(ocrZones != nil) [ocrZones release];
	if(ocrWords != nil) [ocrWords release];
	
	[super dealloc];
}
- (NSString *)nsPrefix
{
	return @"OCRWebServiceSvc";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
	NSString *nodeName = nil;
	if(elNSPrefix != nil && [elNSPrefix length] > 0)
	{
		nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
	}
	else
	{
		nodeName = [NSString stringWithFormat:@"%@:%@", @"OCRWebServiceSvc", elName];
	}
	xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
	
	[self addAttributesToNode:node];
	
	[self addElementsToNode:node];
	
	return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
	
}
- (void)addElementsToNode:(xmlNodePtr)node
{
	
	if(self.ocrLanguages != 0) {
		for(NSNumber *intRepresentation in self.ocrLanguages) {
			OCRWebServiceSvc_OCRWS_Language enumRepresentation = (OCRWebServiceSvc_OCRWS_Language)[intRepresentation intValue];
			xmlNewChild(node, NULL, (const xmlChar*)"OCRWebServiceSvc:ocrLanguages", [OCRWebServiceSvc_OCRWS_Language_stringFromEnum(enumRepresentation) xmlString]);
		}
	}
	if(self.outputDocumentFormat != 0) {
		xmlNewChild(node, NULL, (const xmlChar*)"OCRWebServiceSvc:outputDocumentFormat", [OCRWebServiceSvc_OCRWS_OutputFormat_stringFromEnum(self.outputDocumentFormat) xmlString]);
	}
	if(self.convertToBW != 0) {
		xmlAddChild(node, [self.convertToBW xmlNodeForDoc:node->doc elementName:@"convertToBW" elementNSPrefix:@"OCRWebServiceSvc"]);
	}
	if(self.getOCRText != 0) {
		xmlAddChild(node, [self.getOCRText xmlNodeForDoc:node->doc elementName:@"getOCRText" elementNSPrefix:@"OCRWebServiceSvc"]);
	}
	if(self.createOutputDocument != 0) {
		xmlAddChild(node, [self.createOutputDocument xmlNodeForDoc:node->doc elementName:@"createOutputDocument" elementNSPrefix:@"OCRWebServiceSvc"]);
	}
	if(self.multiPageDoc != 0) {
		xmlAddChild(node, [self.multiPageDoc xmlNodeForDoc:node->doc elementName:@"multiPageDoc" elementNSPrefix:@"OCRWebServiceSvc"]);
	}
	if(self.pageNumbers != 0) {
		xmlAddChild(node, [self.pageNumbers xmlNodeForDoc:node->doc elementName:@"pageNumbers" elementNSPrefix:@"OCRWebServiceSvc"]);
	}
	if(self.ocrZones != 0) {
		xmlAddChild(node, [self.ocrZones xmlNodeForDoc:node->doc elementName:@"ocrZones" elementNSPrefix:@"OCRWebServiceSvc"]);
	}
	if(self.ocrWords != 0) {
		xmlAddChild(node, [self.ocrWords xmlNodeForDoc:node->doc elementName:@"ocrWords" elementNSPrefix:@"OCRWebServiceSvc"]);
	}
}
/* elements */
@synthesize ocrLanguages;
- (void)addOcrLanguages:(OCRWebServiceSvc_OCRWS_Language)toAdd
{
	[ocrLanguages addObject:[NSNumber numberWithInt:(int)toAdd]];
}
@synthesize outputDocumentFormat;
@synthesize convertToBW;
@synthesize getOCRText;
@synthesize createOutputDocument;
@synthesize multiPageDoc;
@synthesize pageNumbers;
@synthesize ocrZones;
@synthesize ocrWords;
/* attributes */
- (NSDictionary *)attributes
{
	NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
	
	return attributes;
}
+ (OCRWebServiceSvc_OCRWSSettings *)deserializeNode:(xmlNodePtr)cur
{
	OCRWebServiceSvc_OCRWSSettings *newObject = [[OCRWebServiceSvc_OCRWSSettings new] autorelease];
	
	[newObject deserializeAttributesFromNode:cur];
	[newObject deserializeElementsFromNode:cur];
	
	return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
	
	
	for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
		if(cur->type == XML_ELEMENT_NODE) {
			xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
			NSString *elementString = nil;
			
			if(elementText != NULL) {
				elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
				[elementString self]; // avoid compiler warning for unused var
				xmlFree(elementText);
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "ocrLanguages")) {
				
				OCRWebServiceSvc_OCRWS_Language enumRepresentation = OCRWebServiceSvc_OCRWS_Language_enumFromString(elementString);
				NSNumber *intRepresentation = [NSNumber numberWithInt:(int)enumRepresentation];
				[self.ocrLanguages addObject:intRepresentation];
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "outputDocumentFormat")) {
				
				OCRWebServiceSvc_OCRWS_OutputFormat enumRepresentation = OCRWebServiceSvc_OCRWS_OutputFormat_enumFromString(elementString);
				self.outputDocumentFormat = enumRepresentation;
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "convertToBW")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [USBoolean class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				self.convertToBW = newChild;
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "getOCRText")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [USBoolean class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				self.getOCRText = newChild;
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "createOutputDocument")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [USBoolean class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				self.createOutputDocument = newChild;
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "multiPageDoc")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [USBoolean class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				self.multiPageDoc = newChild;
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "pageNumbers")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [NSString class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				self.pageNumbers = newChild;
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "ocrZones")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [OCRWebServiceSvc_ArrayOfOCRWSZone class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				self.ocrZones = newChild;
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "ocrWords")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [USBoolean class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				self.ocrWords = newChild;
			}
		}
	}
}
/* NSCoder functions taken from: 
 * http://davedelong.com/blog/2009/04/13/aspect-oriented-programming-objective-c
 */
- (id) initWithCoder:(NSCoder *)decoder {
	if ([super respondsToSelector:@selector(initWithCoder:)] && ![self isKindOfClass:[super class]]) {
		self = [super performSelector:@selector(initWithCoder:) withObject:decoder];
	} else {
		self = [super init];
	}
	if (self == nil) { return nil; }
 
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	unsigned int numIvars = 0;
	Ivar * ivars = class_copyIvarList([self class], &numIvars);
	for(int i = 0; i < numIvars; i++) {
		Ivar thisIvar = ivars[i];
		NSString * key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
		id value = [decoder decodeObjectForKey:key];
		if (value == nil) { value = [NSNumber numberWithFloat:0.0]; }
		[self setValue:value forKey:key];
	}
	if (numIvars > 0) { free(ivars); }
	[pool drain];
	return self;
}
- (void) encodeWithCoder:(NSCoder *)encoder {
	if ([super respondsToSelector:@selector(encodeWithCoder:)] && ![self isKindOfClass:[super class]]) {
		[super performSelector:@selector(encodeWithCoder:) withObject:encoder];
	}
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	unsigned int numIvars = 0;
	Ivar * ivars = class_copyIvarList([self class], &numIvars);
	for (int i = 0; i < numIvars; i++) {
		Ivar thisIvar = ivars[i];
		NSString * key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
		id value = [self valueForKey:key];
		[encoder encodeObject:value forKey:key];
	}
	if (numIvars > 0) { free(ivars); }
	[pool drain];
}
@end
@implementation OCRWebServiceSvc_OCRWebServiceRecognize
@synthesize soapSigner;
- (id)init
{
	if((self = [super init])) {
		user_name = 0;
		license_code = 0;
		OCRWSInputImage = 0;
		OCRWSSetting = 0;
	}
	
	return self;
}
- (void)dealloc
{
	[soapSigner release];
	if(user_name != nil) [user_name release];
	if(license_code != nil) [license_code release];
	if(OCRWSInputImage != nil) [OCRWSInputImage release];
	if(OCRWSSetting != nil) [OCRWSSetting release];
	
	[super dealloc];
}
- (NSString *)nsPrefix
{
	return @"OCRWebServiceSvc";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
	NSString *nodeName = nil;
	if(elNSPrefix != nil && [elNSPrefix length] > 0)
	{
		nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
	}
	else
	{
		nodeName = [NSString stringWithFormat:@"%@:%@", @"OCRWebServiceSvc", elName];
	}
	xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
	
	[self addAttributesToNode:node];
	
	[self addElementsToNode:node];
	
	return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
	
}
- (void)addElementsToNode:(xmlNodePtr)node
{
	
	if(self.user_name != 0) {
		xmlAddChild(node, [self.user_name xmlNodeForDoc:node->doc elementName:@"user_name" elementNSPrefix:@"OCRWebServiceSvc"]);
	}
	if(self.license_code != 0) {
		xmlAddChild(node, [self.license_code xmlNodeForDoc:node->doc elementName:@"license_code" elementNSPrefix:@"OCRWebServiceSvc"]);
	}
	if(self.OCRWSInputImage != 0) {
		xmlAddChild(node, [self.OCRWSInputImage xmlNodeForDoc:node->doc elementName:@"OCRWSInputImage" elementNSPrefix:@"OCRWebServiceSvc"]);
	}
	if(self.OCRWSSetting != 0) {
		xmlAddChild(node, [self.OCRWSSetting xmlNodeForDoc:node->doc elementName:@"OCRWSSetting" elementNSPrefix:@"OCRWebServiceSvc"]);
	}
}
/* elements */
@synthesize user_name;
@synthesize license_code;
@synthesize OCRWSInputImage;
@synthesize OCRWSSetting;
/* attributes */
- (NSDictionary *)attributes
{
	NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
	
	return attributes;
}
+ (OCRWebServiceSvc_OCRWebServiceRecognize *)deserializeNode:(xmlNodePtr)cur
{
	OCRWebServiceSvc_OCRWebServiceRecognize *newObject = [[OCRWebServiceSvc_OCRWebServiceRecognize new] autorelease];
	
	[newObject deserializeAttributesFromNode:cur];
	[newObject deserializeElementsFromNode:cur];
	
	return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
	
	
	for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
		if(cur->type == XML_ELEMENT_NODE) {
			xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
			NSString *elementString = nil;
			
			if(elementText != NULL) {
				elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
				[elementString self]; // avoid compiler warning for unused var
				xmlFree(elementText);
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "user_name")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [NSString class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				self.user_name = newChild;
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "license_code")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [NSString class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				self.license_code = newChild;
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "OCRWSInputImage")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [OCRWebServiceSvc_OCRWSInputImage class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				self.OCRWSInputImage = newChild;
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "OCRWSSetting")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [OCRWebServiceSvc_OCRWSSettings class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				self.OCRWSSetting = newChild;
			}
		}
	}
}
/* NSCoder functions taken from: 
 * http://davedelong.com/blog/2009/04/13/aspect-oriented-programming-objective-c
 */
- (id) initWithCoder:(NSCoder *)decoder {
	if ([super respondsToSelector:@selector(initWithCoder:)] && ![self isKindOfClass:[super class]]) {
		self = [super performSelector:@selector(initWithCoder:) withObject:decoder];
	} else {
		self = [super init];
	}
	if (self == nil) { return nil; }
 
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	unsigned int numIvars = 0;
	Ivar * ivars = class_copyIvarList([self class], &numIvars);
	for(int i = 0; i < numIvars; i++) {
		Ivar thisIvar = ivars[i];
		NSString * key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
		id value = [decoder decodeObjectForKey:key];
		if (value == nil) { value = [NSNumber numberWithFloat:0.0]; }
		[self setValue:value forKey:key];
	}
	if (numIvars > 0) { free(ivars); }
	[pool drain];
	return self;
}
- (void) encodeWithCoder:(NSCoder *)encoder {
	if ([super respondsToSelector:@selector(encodeWithCoder:)] && ![self isKindOfClass:[super class]]) {
		[super performSelector:@selector(encodeWithCoder:) withObject:encoder];
	}
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	unsigned int numIvars = 0;
	Ivar * ivars = class_copyIvarList([self class], &numIvars);
	for (int i = 0; i < numIvars; i++) {
		Ivar thisIvar = ivars[i];
		NSString * key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
		id value = [self valueForKey:key];
		[encoder encodeObject:value forKey:key];
	}
	if (numIvars > 0) { free(ivars); }
	[pool drain];
}
@end
@implementation OCRWebServiceSvc_ArrayOfString
@synthesize soapSigner;
- (id)init
{
	if((self = [super init])) {
		string = [[NSMutableArray alloc] init];
	}
	
	return self;
}
- (void)dealloc
{
	[soapSigner release];
	if(string != nil) [string release];
	
	[super dealloc];
}
- (NSString *)nsPrefix
{
	return @"OCRWebServiceSvc";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
	NSString *nodeName = nil;
	if(elNSPrefix != nil && [elNSPrefix length] > 0)
	{
		nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
	}
	else
	{
		nodeName = [NSString stringWithFormat:@"%@:%@", @"OCRWebServiceSvc", elName];
	}
	xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
	
	[self addAttributesToNode:node];
	
	[self addElementsToNode:node];
	
	return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
	
}
- (void)addElementsToNode:(xmlNodePtr)node
{
	
	if(self.string != 0) {
		for(NSString * child in self.string) {
			xmlAddChild(node, [child xmlNodeForDoc:node->doc elementName:@"string" elementNSPrefix:@"OCRWebServiceSvc"]);
		}
	}
}
/* elements */
@synthesize string;
- (void)addString:(NSString *)toAdd
{
	if(toAdd != nil) [string addObject:toAdd];
}
/* attributes */
- (NSDictionary *)attributes
{
	NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
	
	return attributes;
}
+ (OCRWebServiceSvc_ArrayOfString *)deserializeNode:(xmlNodePtr)cur
{
	OCRWebServiceSvc_ArrayOfString *newObject = [[OCRWebServiceSvc_ArrayOfString new] autorelease];
	
	[newObject deserializeAttributesFromNode:cur];
	[newObject deserializeElementsFromNode:cur];
	
	return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
	
	
	for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
		if(cur->type == XML_ELEMENT_NODE) {
			xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
			NSString *elementString = nil;
			
			if(elementText != NULL) {
				elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
				[elementString self]; // avoid compiler warning for unused var
				xmlFree(elementText);
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "string")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [NSString class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				if(newChild != nil) [self.string addObject:newChild];
			}
		}
	}
}
/* NSCoder functions taken from: 
 * http://davedelong.com/blog/2009/04/13/aspect-oriented-programming-objective-c
 */
- (id) initWithCoder:(NSCoder *)decoder {
	if ([super respondsToSelector:@selector(initWithCoder:)] && ![self isKindOfClass:[super class]]) {
		self = [super performSelector:@selector(initWithCoder:) withObject:decoder];
	} else {
		self = [super init];
	}
	if (self == nil) { return nil; }
 
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	unsigned int numIvars = 0;
	Ivar * ivars = class_copyIvarList([self class], &numIvars);
	for(int i = 0; i < numIvars; i++) {
		Ivar thisIvar = ivars[i];
		NSString * key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
		id value = [decoder decodeObjectForKey:key];
		if (value == nil) { value = [NSNumber numberWithFloat:0.0]; }
		[self setValue:value forKey:key];
	}
	if (numIvars > 0) { free(ivars); }
	[pool drain];
	return self;
}
- (void) encodeWithCoder:(NSCoder *)encoder {
	if ([super respondsToSelector:@selector(encodeWithCoder:)] && ![self isKindOfClass:[super class]]) {
		[super performSelector:@selector(encodeWithCoder:) withObject:encoder];
	}
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	unsigned int numIvars = 0;
	Ivar * ivars = class_copyIvarList([self class], &numIvars);
	for (int i = 0; i < numIvars; i++) {
		Ivar thisIvar = ivars[i];
		NSString * key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
		id value = [self valueForKey:key];
		[encoder encodeObject:value forKey:key];
	}
	if (numIvars > 0) { free(ivars); }
	[pool drain];
}
@end
@implementation OCRWebServiceSvc_ArrayOfArrayOfString
@synthesize soapSigner;
- (id)init
{
	if((self = [super init])) {
		ArrayOfString = [[NSMutableArray alloc] init];
	}
	
	return self;
}
- (void)dealloc
{
	[soapSigner release];
	if(ArrayOfString != nil) [ArrayOfString release];
	
	[super dealloc];
}
- (NSString *)nsPrefix
{
	return @"OCRWebServiceSvc";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
	NSString *nodeName = nil;
	if(elNSPrefix != nil && [elNSPrefix length] > 0)
	{
		nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
	}
	else
	{
		nodeName = [NSString stringWithFormat:@"%@:%@", @"OCRWebServiceSvc", elName];
	}
	xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
	
	[self addAttributesToNode:node];
	
	[self addElementsToNode:node];
	
	return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
	
}
- (void)addElementsToNode:(xmlNodePtr)node
{
	
	if(self.ArrayOfString != 0) {
		for(OCRWebServiceSvc_ArrayOfString * child in self.ArrayOfString) {
			xmlAddChild(node, [child xmlNodeForDoc:node->doc elementName:@"ArrayOfString" elementNSPrefix:@"OCRWebServiceSvc"]);
		}
	}
}
/* elements */
@synthesize ArrayOfString;
- (void)addArrayOfString:(OCRWebServiceSvc_ArrayOfString *)toAdd
{
	if(toAdd != nil) [ArrayOfString addObject:toAdd];
}
/* attributes */
- (NSDictionary *)attributes
{
	NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
	
	return attributes;
}
+ (OCRWebServiceSvc_ArrayOfArrayOfString *)deserializeNode:(xmlNodePtr)cur
{
	OCRWebServiceSvc_ArrayOfArrayOfString *newObject = [[OCRWebServiceSvc_ArrayOfArrayOfString new] autorelease];
	
	[newObject deserializeAttributesFromNode:cur];
	[newObject deserializeElementsFromNode:cur];
	
	return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
	
	
	for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
		if(cur->type == XML_ELEMENT_NODE) {
			xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
			NSString *elementString = nil;
			
			if(elementText != NULL) {
				elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
				[elementString self]; // avoid compiler warning for unused var
				xmlFree(elementText);
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "ArrayOfString")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [OCRWebServiceSvc_ArrayOfString class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				if(newChild != nil) [self.ArrayOfString addObject:newChild];
			}
		}
	}
}
/* NSCoder functions taken from: 
 * http://davedelong.com/blog/2009/04/13/aspect-oriented-programming-objective-c
 */
- (id) initWithCoder:(NSCoder *)decoder {
	if ([super respondsToSelector:@selector(initWithCoder:)] && ![self isKindOfClass:[super class]]) {
		self = [super performSelector:@selector(initWithCoder:) withObject:decoder];
	} else {
		self = [super init];
	}
	if (self == nil) { return nil; }
 
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	unsigned int numIvars = 0;
	Ivar * ivars = class_copyIvarList([self class], &numIvars);
	for(int i = 0; i < numIvars; i++) {
		Ivar thisIvar = ivars[i];
		NSString * key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
		id value = [decoder decodeObjectForKey:key];
		if (value == nil) { value = [NSNumber numberWithFloat:0.0]; }
		[self setValue:value forKey:key];
	}
	if (numIvars > 0) { free(ivars); }
	[pool drain];
	return self;
}
- (void) encodeWithCoder:(NSCoder *)encoder {
	if ([super respondsToSelector:@selector(encodeWithCoder:)] && ![self isKindOfClass:[super class]]) {
		[super performSelector:@selector(encodeWithCoder:) withObject:encoder];
	}
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	unsigned int numIvars = 0;
	Ivar * ivars = class_copyIvarList([self class], &numIvars);
	for (int i = 0; i < numIvars; i++) {
		Ivar thisIvar = ivars[i];
		NSString * key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
		id value = [self valueForKey:key];
		[encoder encodeObject:value forKey:key];
	}
	if (numIvars > 0) { free(ivars); }
	[pool drain];
}
@end
@implementation OCRWebServiceSvc_OCRWSWord
@synthesize soapSigner;
- (id)init
{
	if((self = [super init])) {
		Top = 0;
		Left = 0;
		Height = 0;
		Width = 0;
		OCRWord = 0;
	}
	
	return self;
}
- (void)dealloc
{
	[soapSigner release];
	if(Top != nil) [Top release];
	if(Left != nil) [Left release];
	if(Height != nil) [Height release];
	if(Width != nil) [Width release];
	if(OCRWord != nil) [OCRWord release];
	
	[super dealloc];
}
- (NSString *)nsPrefix
{
	return @"OCRWebServiceSvc";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
	NSString *nodeName = nil;
	if(elNSPrefix != nil && [elNSPrefix length] > 0)
	{
		nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
	}
	else
	{
		nodeName = [NSString stringWithFormat:@"%@:%@", @"OCRWebServiceSvc", elName];
	}
	xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
	
	[self addAttributesToNode:node];
	
	[self addElementsToNode:node];
	
	return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
	
}
- (void)addElementsToNode:(xmlNodePtr)node
{
	
	if(self.Top != 0) {
		xmlAddChild(node, [self.Top xmlNodeForDoc:node->doc elementName:@"Top" elementNSPrefix:@"OCRWebServiceSvc"]);
	}
	if(self.Left != 0) {
		xmlAddChild(node, [self.Left xmlNodeForDoc:node->doc elementName:@"Left" elementNSPrefix:@"OCRWebServiceSvc"]);
	}
	if(self.Height != 0) {
		xmlAddChild(node, [self.Height xmlNodeForDoc:node->doc elementName:@"Height" elementNSPrefix:@"OCRWebServiceSvc"]);
	}
	if(self.Width != 0) {
		xmlAddChild(node, [self.Width xmlNodeForDoc:node->doc elementName:@"Width" elementNSPrefix:@"OCRWebServiceSvc"]);
	}
	if(self.OCRWord != 0) {
		xmlAddChild(node, [self.OCRWord xmlNodeForDoc:node->doc elementName:@"OCRWord" elementNSPrefix:@"OCRWebServiceSvc"]);
	}
}
/* elements */
@synthesize Top;
@synthesize Left;
@synthesize Height;
@synthesize Width;
@synthesize OCRWord;
/* attributes */
- (NSDictionary *)attributes
{
	NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
	
	return attributes;
}
+ (OCRWebServiceSvc_OCRWSWord *)deserializeNode:(xmlNodePtr)cur
{
	OCRWebServiceSvc_OCRWSWord *newObject = [[OCRWebServiceSvc_OCRWSWord new] autorelease];
	
	[newObject deserializeAttributesFromNode:cur];
	[newObject deserializeElementsFromNode:cur];
	
	return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
	
	
	for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
		if(cur->type == XML_ELEMENT_NODE) {
			xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
			NSString *elementString = nil;
			
			if(elementText != NULL) {
				elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
				[elementString self]; // avoid compiler warning for unused var
				xmlFree(elementText);
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "Top")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [NSNumber class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				self.Top = newChild;
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "Left")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [NSNumber class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				self.Left = newChild;
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "Height")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [NSNumber class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				self.Height = newChild;
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "Width")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [NSNumber class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				self.Width = newChild;
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "OCRWord")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [NSString class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				self.OCRWord = newChild;
			}
		}
	}
}
/* NSCoder functions taken from: 
 * http://davedelong.com/blog/2009/04/13/aspect-oriented-programming-objective-c
 */
- (id) initWithCoder:(NSCoder *)decoder {
	if ([super respondsToSelector:@selector(initWithCoder:)] && ![self isKindOfClass:[super class]]) {
		self = [super performSelector:@selector(initWithCoder:) withObject:decoder];
	} else {
		self = [super init];
	}
	if (self == nil) { return nil; }
 
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	unsigned int numIvars = 0;
	Ivar * ivars = class_copyIvarList([self class], &numIvars);
	for(int i = 0; i < numIvars; i++) {
		Ivar thisIvar = ivars[i];
		NSString * key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
		id value = [decoder decodeObjectForKey:key];
		if (value == nil) { value = [NSNumber numberWithFloat:0.0]; }
		[self setValue:value forKey:key];
	}
	if (numIvars > 0) { free(ivars); }
	[pool drain];
	return self;
}
- (void) encodeWithCoder:(NSCoder *)encoder {
	if ([super respondsToSelector:@selector(encodeWithCoder:)] && ![self isKindOfClass:[super class]]) {
		[super performSelector:@selector(encodeWithCoder:) withObject:encoder];
	}
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	unsigned int numIvars = 0;
	Ivar * ivars = class_copyIvarList([self class], &numIvars);
	for (int i = 0; i < numIvars; i++) {
		Ivar thisIvar = ivars[i];
		NSString * key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
		id value = [self valueForKey:key];
		[encoder encodeObject:value forKey:key];
	}
	if (numIvars > 0) { free(ivars); }
	[pool drain];
}
@end
@implementation OCRWebServiceSvc_ArrayOfOCRWSWord
@synthesize soapSigner;
- (id)init
{
	if((self = [super init])) {
		OCRWSWord = [[NSMutableArray alloc] init];
	}
	
	return self;
}
- (void)dealloc
{
	[soapSigner release];
	if(OCRWSWord != nil) [OCRWSWord release];
	
	[super dealloc];
}
- (NSString *)nsPrefix
{
	return @"OCRWebServiceSvc";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
	NSString *nodeName = nil;
	if(elNSPrefix != nil && [elNSPrefix length] > 0)
	{
		nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
	}
	else
	{
		nodeName = [NSString stringWithFormat:@"%@:%@", @"OCRWebServiceSvc", elName];
	}
	xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
	
	[self addAttributesToNode:node];
	
	[self addElementsToNode:node];
	
	return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
	
}
- (void)addElementsToNode:(xmlNodePtr)node
{
	
	if(self.OCRWSWord != 0) {
		for(OCRWebServiceSvc_OCRWSWord * child in self.OCRWSWord) {
			xmlAddChild(node, [child xmlNodeForDoc:node->doc elementName:@"OCRWSWord" elementNSPrefix:@"OCRWebServiceSvc"]);
		}
	}
}
/* elements */
@synthesize OCRWSWord;
- (void)addOCRWSWord:(OCRWebServiceSvc_OCRWSWord *)toAdd
{
	if(toAdd != nil) [OCRWSWord addObject:toAdd];
}
/* attributes */
- (NSDictionary *)attributes
{
	NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
	
	return attributes;
}
+ (OCRWebServiceSvc_ArrayOfOCRWSWord *)deserializeNode:(xmlNodePtr)cur
{
	OCRWebServiceSvc_ArrayOfOCRWSWord *newObject = [[OCRWebServiceSvc_ArrayOfOCRWSWord new] autorelease];
	
	[newObject deserializeAttributesFromNode:cur];
	[newObject deserializeElementsFromNode:cur];
	
	return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
	
	
	for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
		if(cur->type == XML_ELEMENT_NODE) {
			xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
			NSString *elementString = nil;
			
			if(elementText != NULL) {
				elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
				[elementString self]; // avoid compiler warning for unused var
				xmlFree(elementText);
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "OCRWSWord")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [OCRWebServiceSvc_OCRWSWord class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				if(newChild != nil) [self.OCRWSWord addObject:newChild];
			}
		}
	}
}
/* NSCoder functions taken from: 
 * http://davedelong.com/blog/2009/04/13/aspect-oriented-programming-objective-c
 */
- (id) initWithCoder:(NSCoder *)decoder {
	if ([super respondsToSelector:@selector(initWithCoder:)] && ![self isKindOfClass:[super class]]) {
		self = [super performSelector:@selector(initWithCoder:) withObject:decoder];
	} else {
		self = [super init];
	}
	if (self == nil) { return nil; }
 
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	unsigned int numIvars = 0;
	Ivar * ivars = class_copyIvarList([self class], &numIvars);
	for(int i = 0; i < numIvars; i++) {
		Ivar thisIvar = ivars[i];
		NSString * key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
		id value = [decoder decodeObjectForKey:key];
		if (value == nil) { value = [NSNumber numberWithFloat:0.0]; }
		[self setValue:value forKey:key];
	}
	if (numIvars > 0) { free(ivars); }
	[pool drain];
	return self;
}
- (void) encodeWithCoder:(NSCoder *)encoder {
	if ([super respondsToSelector:@selector(encodeWithCoder:)] && ![self isKindOfClass:[super class]]) {
		[super performSelector:@selector(encodeWithCoder:) withObject:encoder];
	}
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	unsigned int numIvars = 0;
	Ivar * ivars = class_copyIvarList([self class], &numIvars);
	for (int i = 0; i < numIvars; i++) {
		Ivar thisIvar = ivars[i];
		NSString * key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
		id value = [self valueForKey:key];
		[encoder encodeObject:value forKey:key];
	}
	if (numIvars > 0) { free(ivars); }
	[pool drain];
}
@end
@implementation OCRWebServiceSvc_ArrayOfArrayOfOCRWSWord
@synthesize soapSigner;
- (id)init
{
	if((self = [super init])) {
		ArrayOfOCRWSWord = [[NSMutableArray alloc] init];
	}
	
	return self;
}
- (void)dealloc
{
	[soapSigner release];
	if(ArrayOfOCRWSWord != nil) [ArrayOfOCRWSWord release];
	
	[super dealloc];
}
- (NSString *)nsPrefix
{
	return @"OCRWebServiceSvc";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
	NSString *nodeName = nil;
	if(elNSPrefix != nil && [elNSPrefix length] > 0)
	{
		nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
	}
	else
	{
		nodeName = [NSString stringWithFormat:@"%@:%@", @"OCRWebServiceSvc", elName];
	}
	xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
	
	[self addAttributesToNode:node];
	
	[self addElementsToNode:node];
	
	return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
	
}
- (void)addElementsToNode:(xmlNodePtr)node
{
	
	if(self.ArrayOfOCRWSWord != 0) {
		for(OCRWebServiceSvc_ArrayOfOCRWSWord * child in self.ArrayOfOCRWSWord) {
			xmlAddChild(node, [child xmlNodeForDoc:node->doc elementName:@"ArrayOfOCRWSWord" elementNSPrefix:@"OCRWebServiceSvc"]);
		}
	}
}
/* elements */
@synthesize ArrayOfOCRWSWord;
- (void)addArrayOfOCRWSWord:(OCRWebServiceSvc_ArrayOfOCRWSWord *)toAdd
{
	if(toAdd != nil) [ArrayOfOCRWSWord addObject:toAdd];
}
/* attributes */
- (NSDictionary *)attributes
{
	NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
	
	return attributes;
}
+ (OCRWebServiceSvc_ArrayOfArrayOfOCRWSWord *)deserializeNode:(xmlNodePtr)cur
{
	OCRWebServiceSvc_ArrayOfArrayOfOCRWSWord *newObject = [[OCRWebServiceSvc_ArrayOfArrayOfOCRWSWord new] autorelease];
	
	[newObject deserializeAttributesFromNode:cur];
	[newObject deserializeElementsFromNode:cur];
	
	return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
	
	
	for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
		if(cur->type == XML_ELEMENT_NODE) {
			xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
			NSString *elementString = nil;
			
			if(elementText != NULL) {
				elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
				[elementString self]; // avoid compiler warning for unused var
				xmlFree(elementText);
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "ArrayOfOCRWSWord")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [OCRWebServiceSvc_ArrayOfOCRWSWord class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				if(newChild != nil) [self.ArrayOfOCRWSWord addObject:newChild];
			}
		}
	}
}
/* NSCoder functions taken from: 
 * http://davedelong.com/blog/2009/04/13/aspect-oriented-programming-objective-c
 */
- (id) initWithCoder:(NSCoder *)decoder {
	if ([super respondsToSelector:@selector(initWithCoder:)] && ![self isKindOfClass:[super class]]) {
		self = [super performSelector:@selector(initWithCoder:) withObject:decoder];
	} else {
		self = [super init];
	}
	if (self == nil) { return nil; }
 
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	unsigned int numIvars = 0;
	Ivar * ivars = class_copyIvarList([self class], &numIvars);
	for(int i = 0; i < numIvars; i++) {
		Ivar thisIvar = ivars[i];
		NSString * key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
		id value = [decoder decodeObjectForKey:key];
		if (value == nil) { value = [NSNumber numberWithFloat:0.0]; }
		[self setValue:value forKey:key];
	}
	if (numIvars > 0) { free(ivars); }
	[pool drain];
	return self;
}
- (void) encodeWithCoder:(NSCoder *)encoder {
	if ([super respondsToSelector:@selector(encodeWithCoder:)] && ![self isKindOfClass:[super class]]) {
		[super performSelector:@selector(encodeWithCoder:) withObject:encoder];
	}
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	unsigned int numIvars = 0;
	Ivar * ivars = class_copyIvarList([self class], &numIvars);
	for (int i = 0; i < numIvars; i++) {
		Ivar thisIvar = ivars[i];
		NSString * key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
		id value = [self valueForKey:key];
		[encoder encodeObject:value forKey:key];
	}
	if (numIvars > 0) { free(ivars); }
	[pool drain];
}
@end
@implementation OCRWebServiceSvc_OCRWSResponse
@synthesize soapSigner;
- (id)init
{
	if((self = [super init])) {
		ocrText = 0;
		fileName = 0;
		fileData = 0;
		errorMessage = 0;
		ocrWSWords = 0;
	}
	
	return self;
}
- (void)dealloc
{
	[soapSigner release];
	if(ocrText != nil) [ocrText release];
	if(fileName != nil) [fileName release];
	if(fileData != nil) [fileData release];
	if(errorMessage != nil) [errorMessage release];
	if(ocrWSWords != nil) [ocrWSWords release];
	
	[super dealloc];
}
- (NSString *)nsPrefix
{
	return @"OCRWebServiceSvc";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
	NSString *nodeName = nil;
	if(elNSPrefix != nil && [elNSPrefix length] > 0)
	{
		nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
	}
	else
	{
		nodeName = [NSString stringWithFormat:@"%@:%@", @"OCRWebServiceSvc", elName];
	}
	xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
	
	[self addAttributesToNode:node];
	
	[self addElementsToNode:node];
	
	return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
	
}
- (void)addElementsToNode:(xmlNodePtr)node
{
	
	if(self.ocrText != 0) {
		xmlAddChild(node, [self.ocrText xmlNodeForDoc:node->doc elementName:@"ocrText" elementNSPrefix:@"OCRWebServiceSvc"]);
	}
	if(self.fileName != 0) {
		xmlAddChild(node, [self.fileName xmlNodeForDoc:node->doc elementName:@"fileName" elementNSPrefix:@"OCRWebServiceSvc"]);
	}
	if(self.fileData != 0) {
		xmlAddChild(node, [self.fileData xmlNodeForDoc:node->doc elementName:@"fileData" elementNSPrefix:@"OCRWebServiceSvc"]);
	}
	if(self.errorMessage != 0) {
		xmlAddChild(node, [self.errorMessage xmlNodeForDoc:node->doc elementName:@"errorMessage" elementNSPrefix:@"OCRWebServiceSvc"]);
	}
	if(self.ocrWSWords != 0) {
		xmlAddChild(node, [self.ocrWSWords xmlNodeForDoc:node->doc elementName:@"ocrWSWords" elementNSPrefix:@"OCRWebServiceSvc"]);
	}
}
/* elements */
@synthesize ocrText;
@synthesize fileName;
@synthesize fileData;
@synthesize errorMessage;
@synthesize ocrWSWords;
/* attributes */
- (NSDictionary *)attributes
{
	NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
	
	return attributes;
}
+ (OCRWebServiceSvc_OCRWSResponse *)deserializeNode:(xmlNodePtr)cur
{
	OCRWebServiceSvc_OCRWSResponse *newObject = [[OCRWebServiceSvc_OCRWSResponse new] autorelease];
	
	[newObject deserializeAttributesFromNode:cur];
	[newObject deserializeElementsFromNode:cur];
	
	return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
	
	
	for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
		if(cur->type == XML_ELEMENT_NODE) {
			xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
			NSString *elementString = nil;
			
			if(elementText != NULL) {
				elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
				[elementString self]; // avoid compiler warning for unused var
				xmlFree(elementText);
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "ocrText")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [OCRWebServiceSvc_ArrayOfArrayOfString class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				self.ocrText = newChild;
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "fileName")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [NSString class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				self.fileName = newChild;
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "fileData")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [NSData class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				self.fileData = newChild;
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "errorMessage")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [NSString class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				self.errorMessage = newChild;
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "ocrWSWords")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [OCRWebServiceSvc_ArrayOfArrayOfOCRWSWord class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				self.ocrWSWords = newChild;
			}
		}
	}
}
/* NSCoder functions taken from: 
 * http://davedelong.com/blog/2009/04/13/aspect-oriented-programming-objective-c
 */
- (id) initWithCoder:(NSCoder *)decoder {
	if ([super respondsToSelector:@selector(initWithCoder:)] && ![self isKindOfClass:[super class]]) {
		self = [super performSelector:@selector(initWithCoder:) withObject:decoder];
	} else {
		self = [super init];
	}
	if (self == nil) { return nil; }
 
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	unsigned int numIvars = 0;
	Ivar * ivars = class_copyIvarList([self class], &numIvars);
	for(int i = 0; i < numIvars; i++) {
		Ivar thisIvar = ivars[i];
		NSString * key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
		id value = [decoder decodeObjectForKey:key];
		if (value == nil) { value = [NSNumber numberWithFloat:0.0]; }
		[self setValue:value forKey:key];
	}
	if (numIvars > 0) { free(ivars); }
	[pool drain];
	return self;
}
- (void) encodeWithCoder:(NSCoder *)encoder {
	if ([super respondsToSelector:@selector(encodeWithCoder:)] && ![self isKindOfClass:[super class]]) {
		[super performSelector:@selector(encodeWithCoder:) withObject:encoder];
	}
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	unsigned int numIvars = 0;
	Ivar * ivars = class_copyIvarList([self class], &numIvars);
	for (int i = 0; i < numIvars; i++) {
		Ivar thisIvar = ivars[i];
		NSString * key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
		id value = [self valueForKey:key];
		[encoder encodeObject:value forKey:key];
	}
	if (numIvars > 0) { free(ivars); }
	[pool drain];
}
@end
@implementation OCRWebServiceSvc_OCRWebServiceRecognizeResponse
@synthesize soapSigner;
- (id)init
{
	if((self = [super init])) {
		OCRWSResponse = 0;
	}
	
	return self;
}
- (void)dealloc
{
	[soapSigner release];
	if(OCRWSResponse != nil) [OCRWSResponse release];
	
	[super dealloc];
}
- (NSString *)nsPrefix
{
	return @"OCRWebServiceSvc";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
	NSString *nodeName = nil;
	if(elNSPrefix != nil && [elNSPrefix length] > 0)
	{
		nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
	}
	else
	{
		nodeName = [NSString stringWithFormat:@"%@:%@", @"OCRWebServiceSvc", elName];
	}
	xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
	
	[self addAttributesToNode:node];
	
	[self addElementsToNode:node];
	
	return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
	
}
- (void)addElementsToNode:(xmlNodePtr)node
{
	
	if(self.OCRWSResponse != 0) {
		xmlAddChild(node, [self.OCRWSResponse xmlNodeForDoc:node->doc elementName:@"OCRWSResponse" elementNSPrefix:@"OCRWebServiceSvc"]);
	}
}
/* elements */
@synthesize OCRWSResponse;
/* attributes */
- (NSDictionary *)attributes
{
	NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
	
	return attributes;
}
+ (OCRWebServiceSvc_OCRWebServiceRecognizeResponse *)deserializeNode:(xmlNodePtr)cur
{
	OCRWebServiceSvc_OCRWebServiceRecognizeResponse *newObject = [[OCRWebServiceSvc_OCRWebServiceRecognizeResponse new] autorelease];
	
	[newObject deserializeAttributesFromNode:cur];
	[newObject deserializeElementsFromNode:cur];
	
	return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
	
	
	for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
		if(cur->type == XML_ELEMENT_NODE) {
			xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
			NSString *elementString = nil;
			
			if(elementText != NULL) {
				elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
				[elementString self]; // avoid compiler warning for unused var
				xmlFree(elementText);
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "OCRWSResponse")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [OCRWebServiceSvc_OCRWSResponse class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				self.OCRWSResponse = newChild;
			}
		}
	}
}
/* NSCoder functions taken from: 
 * http://davedelong.com/blog/2009/04/13/aspect-oriented-programming-objective-c
 */
- (id) initWithCoder:(NSCoder *)decoder {
	if ([super respondsToSelector:@selector(initWithCoder:)] && ![self isKindOfClass:[super class]]) {
		self = [super performSelector:@selector(initWithCoder:) withObject:decoder];
	} else {
		self = [super init];
	}
	if (self == nil) { return nil; }
 
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	unsigned int numIvars = 0;
	Ivar * ivars = class_copyIvarList([self class], &numIvars);
	for(int i = 0; i < numIvars; i++) {
		Ivar thisIvar = ivars[i];
		NSString * key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
		id value = [decoder decodeObjectForKey:key];
		if (value == nil) { value = [NSNumber numberWithFloat:0.0]; }
		[self setValue:value forKey:key];
	}
	if (numIvars > 0) { free(ivars); }
	[pool drain];
	return self;
}
- (void) encodeWithCoder:(NSCoder *)encoder {
	if ([super respondsToSelector:@selector(encodeWithCoder:)] && ![self isKindOfClass:[super class]]) {
		[super performSelector:@selector(encodeWithCoder:) withObject:encoder];
	}
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	unsigned int numIvars = 0;
	Ivar * ivars = class_copyIvarList([self class], &numIvars);
	for (int i = 0; i < numIvars; i++) {
		Ivar thisIvar = ivars[i];
		NSString * key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
		id value = [self valueForKey:key];
		[encoder encodeObject:value forKey:key];
	}
	if (numIvars > 0) { free(ivars); }
	[pool drain];
}
@end
@implementation OCRWebServiceSvc_OCRWebServiceLog
@synthesize soapSigner;
- (id)init
{
	if((self = [super init])) {
		user_name = 0;
		license_code = 0;
		from_date = 0;
		to_date = 0;
		reserved = 0;
	}
	
	return self;
}
- (void)dealloc
{
	[soapSigner release];
	if(user_name != nil) [user_name release];
	if(license_code != nil) [license_code release];
	if(from_date != nil) [from_date release];
	if(to_date != nil) [to_date release];
	if(reserved != nil) [reserved release];
	
	[super dealloc];
}
- (NSString *)nsPrefix
{
	return @"OCRWebServiceSvc";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
	NSString *nodeName = nil;
	if(elNSPrefix != nil && [elNSPrefix length] > 0)
	{
		nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
	}
	else
	{
		nodeName = [NSString stringWithFormat:@"%@:%@", @"OCRWebServiceSvc", elName];
	}
	xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
	
	[self addAttributesToNode:node];
	
	[self addElementsToNode:node];
	
	return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
	
}
- (void)addElementsToNode:(xmlNodePtr)node
{
	
	if(self.user_name != 0) {
		xmlAddChild(node, [self.user_name xmlNodeForDoc:node->doc elementName:@"user_name" elementNSPrefix:@"OCRWebServiceSvc"]);
	}
	if(self.license_code != 0) {
		xmlAddChild(node, [self.license_code xmlNodeForDoc:node->doc elementName:@"license_code" elementNSPrefix:@"OCRWebServiceSvc"]);
	}
	if(self.from_date != 0) {
		xmlAddChild(node, [self.from_date xmlNodeForDoc:node->doc elementName:@"from_date" elementNSPrefix:@"OCRWebServiceSvc"]);
	}
	if(self.to_date != 0) {
		xmlAddChild(node, [self.to_date xmlNodeForDoc:node->doc elementName:@"to_date" elementNSPrefix:@"OCRWebServiceSvc"]);
	}
	if(self.reserved != 0) {
		xmlAddChild(node, [self.reserved xmlNodeForDoc:node->doc elementName:@"reserved" elementNSPrefix:@"OCRWebServiceSvc"]);
	}
}
/* elements */
@synthesize user_name;
@synthesize license_code;
@synthesize from_date;
@synthesize to_date;
@synthesize reserved;
/* attributes */
- (NSDictionary *)attributes
{
	NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
	
	return attributes;
}
+ (OCRWebServiceSvc_OCRWebServiceLog *)deserializeNode:(xmlNodePtr)cur
{
	OCRWebServiceSvc_OCRWebServiceLog *newObject = [[OCRWebServiceSvc_OCRWebServiceLog new] autorelease];
	
	[newObject deserializeAttributesFromNode:cur];
	[newObject deserializeElementsFromNode:cur];
	
	return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
	
	
	for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
		if(cur->type == XML_ELEMENT_NODE) {
			xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
			NSString *elementString = nil;
			
			if(elementText != NULL) {
				elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
				[elementString self]; // avoid compiler warning for unused var
				xmlFree(elementText);
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "user_name")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [NSString class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				self.user_name = newChild;
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "license_code")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [NSString class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				self.license_code = newChild;
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "from_date")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [NSString class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				self.from_date = newChild;
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "to_date")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [NSString class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				self.to_date = newChild;
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "reserved")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [OCRWebServiceSvc_ArrayOfString class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				self.reserved = newChild;
			}
		}
	}
}
/* NSCoder functions taken from: 
 * http://davedelong.com/blog/2009/04/13/aspect-oriented-programming-objective-c
 */
- (id) initWithCoder:(NSCoder *)decoder {
	if ([super respondsToSelector:@selector(initWithCoder:)] && ![self isKindOfClass:[super class]]) {
		self = [super performSelector:@selector(initWithCoder:) withObject:decoder];
	} else {
		self = [super init];
	}
	if (self == nil) { return nil; }
 
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	unsigned int numIvars = 0;
	Ivar * ivars = class_copyIvarList([self class], &numIvars);
	for(int i = 0; i < numIvars; i++) {
		Ivar thisIvar = ivars[i];
		NSString * key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
		id value = [decoder decodeObjectForKey:key];
		if (value == nil) { value = [NSNumber numberWithFloat:0.0]; }
		[self setValue:value forKey:key];
	}
	if (numIvars > 0) { free(ivars); }
	[pool drain];
	return self;
}
- (void) encodeWithCoder:(NSCoder *)encoder {
	if ([super respondsToSelector:@selector(encodeWithCoder:)] && ![self isKindOfClass:[super class]]) {
		[super performSelector:@selector(encodeWithCoder:) withObject:encoder];
	}
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	unsigned int numIvars = 0;
	Ivar * ivars = class_copyIvarList([self class], &numIvars);
	for (int i = 0; i < numIvars; i++) {
		Ivar thisIvar = ivars[i];
		NSString * key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
		id value = [self valueForKey:key];
		[encoder encodeObject:value forKey:key];
	}
	if (numIvars > 0) { free(ivars); }
	[pool drain];
}
@end
@implementation OCRWebServiceSvc_OCRWebServiceLogResponse
@synthesize soapSigner;
- (id)init
{
	if((self = [super init])) {
		OCRWebServiceLogResult = 0;
	}
	
	return self;
}
- (void)dealloc
{
	[soapSigner release];
	if(OCRWebServiceLogResult != nil) [OCRWebServiceLogResult release];
	
	[super dealloc];
}
- (NSString *)nsPrefix
{
	return @"OCRWebServiceSvc";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
	NSString *nodeName = nil;
	if(elNSPrefix != nil && [elNSPrefix length] > 0)
	{
		nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
	}
	else
	{
		nodeName = [NSString stringWithFormat:@"%@:%@", @"OCRWebServiceSvc", elName];
	}
	xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
	
	[self addAttributesToNode:node];
	
	[self addElementsToNode:node];
	
	return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
	
}
- (void)addElementsToNode:(xmlNodePtr)node
{
	
	if(self.OCRWebServiceLogResult != 0) {
		xmlAddChild(node, [self.OCRWebServiceLogResult xmlNodeForDoc:node->doc elementName:@"OCRWebServiceLogResult" elementNSPrefix:@"OCRWebServiceSvc"]);
	}
}
/* elements */
@synthesize OCRWebServiceLogResult;
/* attributes */
- (NSDictionary *)attributes
{
	NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
	
	return attributes;
}
+ (OCRWebServiceSvc_OCRWebServiceLogResponse *)deserializeNode:(xmlNodePtr)cur
{
	OCRWebServiceSvc_OCRWebServiceLogResponse *newObject = [[OCRWebServiceSvc_OCRWebServiceLogResponse new] autorelease];
	
	[newObject deserializeAttributesFromNode:cur];
	[newObject deserializeElementsFromNode:cur];
	
	return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
	
	
	for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
		if(cur->type == XML_ELEMENT_NODE) {
			xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
			NSString *elementString = nil;
			
			if(elementText != NULL) {
				elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
				[elementString self]; // avoid compiler warning for unused var
				xmlFree(elementText);
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "OCRWebServiceLogResult")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [NSString class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				self.OCRWebServiceLogResult = newChild;
			}
		}
	}
}
/* NSCoder functions taken from: 
 * http://davedelong.com/blog/2009/04/13/aspect-oriented-programming-objective-c
 */
- (id) initWithCoder:(NSCoder *)decoder {
	if ([super respondsToSelector:@selector(initWithCoder:)] && ![self isKindOfClass:[super class]]) {
		self = [super performSelector:@selector(initWithCoder:) withObject:decoder];
	} else {
		self = [super init];
	}
	if (self == nil) { return nil; }
 
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	unsigned int numIvars = 0;
	Ivar * ivars = class_copyIvarList([self class], &numIvars);
	for(int i = 0; i < numIvars; i++) {
		Ivar thisIvar = ivars[i];
		NSString * key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
		id value = [decoder decodeObjectForKey:key];
		if (value == nil) { value = [NSNumber numberWithFloat:0.0]; }
		[self setValue:value forKey:key];
	}
	if (numIvars > 0) { free(ivars); }
	[pool drain];
	return self;
}
- (void) encodeWithCoder:(NSCoder *)encoder {
	if ([super respondsToSelector:@selector(encodeWithCoder:)] && ![self isKindOfClass:[super class]]) {
		[super performSelector:@selector(encodeWithCoder:) withObject:encoder];
	}
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	unsigned int numIvars = 0;
	Ivar * ivars = class_copyIvarList([self class], &numIvars);
	for (int i = 0; i < numIvars; i++) {
		Ivar thisIvar = ivars[i];
		NSString * key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
		id value = [self valueForKey:key];
		[encoder encodeObject:value forKey:key];
	}
	if (numIvars > 0) { free(ivars); }
	[pool drain];
}
@end
@implementation OCRWebServiceSvc_OCRWebServiceAvailablePages
@synthesize soapSigner;
- (id)init
{
	if((self = [super init])) {
		user_name = 0;
		license_code = 0;
	}
	
	return self;
}
- (void)dealloc
{
	[soapSigner release];
	if(user_name != nil) [user_name release];
	if(license_code != nil) [license_code release];
	
	[super dealloc];
}
- (NSString *)nsPrefix
{
	return @"OCRWebServiceSvc";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
	NSString *nodeName = nil;
	if(elNSPrefix != nil && [elNSPrefix length] > 0)
	{
		nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
	}
	else
	{
		nodeName = [NSString stringWithFormat:@"%@:%@", @"OCRWebServiceSvc", elName];
	}
	xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
	
	[self addAttributesToNode:node];
	
	[self addElementsToNode:node];
	
	return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
	
}
- (void)addElementsToNode:(xmlNodePtr)node
{
	
	if(self.user_name != 0) {
		xmlAddChild(node, [self.user_name xmlNodeForDoc:node->doc elementName:@"user_name" elementNSPrefix:@"OCRWebServiceSvc"]);
	}
	if(self.license_code != 0) {
		xmlAddChild(node, [self.license_code xmlNodeForDoc:node->doc elementName:@"license_code" elementNSPrefix:@"OCRWebServiceSvc"]);
	}
}
/* elements */
@synthesize user_name;
@synthesize license_code;
/* attributes */
- (NSDictionary *)attributes
{
	NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
	
	return attributes;
}
+ (OCRWebServiceSvc_OCRWebServiceAvailablePages *)deserializeNode:(xmlNodePtr)cur
{
	OCRWebServiceSvc_OCRWebServiceAvailablePages *newObject = [[OCRWebServiceSvc_OCRWebServiceAvailablePages new] autorelease];
	
	[newObject deserializeAttributesFromNode:cur];
	[newObject deserializeElementsFromNode:cur];
	
	return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
	
	
	for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
		if(cur->type == XML_ELEMENT_NODE) {
			xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
			NSString *elementString = nil;
			
			if(elementText != NULL) {
				elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
				[elementString self]; // avoid compiler warning for unused var
				xmlFree(elementText);
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "user_name")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [NSString class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				self.user_name = newChild;
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "license_code")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [NSString class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				self.license_code = newChild;
			}
		}
	}
}
/* NSCoder functions taken from: 
 * http://davedelong.com/blog/2009/04/13/aspect-oriented-programming-objective-c
 */
- (id) initWithCoder:(NSCoder *)decoder {
	if ([super respondsToSelector:@selector(initWithCoder:)] && ![self isKindOfClass:[super class]]) {
		self = [super performSelector:@selector(initWithCoder:) withObject:decoder];
	} else {
		self = [super init];
	}
	if (self == nil) { return nil; }
 
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	unsigned int numIvars = 0;
	Ivar * ivars = class_copyIvarList([self class], &numIvars);
	for(int i = 0; i < numIvars; i++) {
		Ivar thisIvar = ivars[i];
		NSString * key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
		id value = [decoder decodeObjectForKey:key];
		if (value == nil) { value = [NSNumber numberWithFloat:0.0]; }
		[self setValue:value forKey:key];
	}
	if (numIvars > 0) { free(ivars); }
	[pool drain];
	return self;
}
- (void) encodeWithCoder:(NSCoder *)encoder {
	if ([super respondsToSelector:@selector(encodeWithCoder:)] && ![self isKindOfClass:[super class]]) {
		[super performSelector:@selector(encodeWithCoder:) withObject:encoder];
	}
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	unsigned int numIvars = 0;
	Ivar * ivars = class_copyIvarList([self class], &numIvars);
	for (int i = 0; i < numIvars; i++) {
		Ivar thisIvar = ivars[i];
		NSString * key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
		id value = [self valueForKey:key];
		[encoder encodeObject:value forKey:key];
	}
	if (numIvars > 0) { free(ivars); }
	[pool drain];
}
@end
@implementation OCRWebServiceSvc_OCRWebServiceAvailablePagesResponse
@synthesize soapSigner;
- (id)init
{
	if((self = [super init])) {
		OCRWebServiceAvailablePagesResult = 0;
	}
	
	return self;
}
- (void)dealloc
{
	[soapSigner release];
	if(OCRWebServiceAvailablePagesResult != nil) [OCRWebServiceAvailablePagesResult release];
	
	[super dealloc];
}
- (NSString *)nsPrefix
{
	return @"OCRWebServiceSvc";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
	NSString *nodeName = nil;
	if(elNSPrefix != nil && [elNSPrefix length] > 0)
	{
		nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
	}
	else
	{
		nodeName = [NSString stringWithFormat:@"%@:%@", @"OCRWebServiceSvc", elName];
	}
	xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
	
	[self addAttributesToNode:node];
	
	[self addElementsToNode:node];
	
	return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
	
}
- (void)addElementsToNode:(xmlNodePtr)node
{
	
	if(self.OCRWebServiceAvailablePagesResult != 0) {
		xmlAddChild(node, [self.OCRWebServiceAvailablePagesResult xmlNodeForDoc:node->doc elementName:@"OCRWebServiceAvailablePagesResult" elementNSPrefix:@"OCRWebServiceSvc"]);
	}
}
/* elements */
@synthesize OCRWebServiceAvailablePagesResult;
/* attributes */
- (NSDictionary *)attributes
{
	NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
	
	return attributes;
}
+ (OCRWebServiceSvc_OCRWebServiceAvailablePagesResponse *)deserializeNode:(xmlNodePtr)cur
{
	OCRWebServiceSvc_OCRWebServiceAvailablePagesResponse *newObject = [[OCRWebServiceSvc_OCRWebServiceAvailablePagesResponse new] autorelease];
	
	[newObject deserializeAttributesFromNode:cur];
	[newObject deserializeElementsFromNode:cur];
	
	return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
	
	
	for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
		if(cur->type == XML_ELEMENT_NODE) {
			xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
			NSString *elementString = nil;
			
			if(elementText != NULL) {
				elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
				[elementString self]; // avoid compiler warning for unused var
				xmlFree(elementText);
			}
			if(xmlStrEqual(cur->name, (const xmlChar *) "OCRWebServiceAvailablePagesResult")) {
				
				Class elementClass = nil;
				xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
				if(instanceType == NULL) {
					elementClass = [NSNumber class];
				} else {
					NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
					
					NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
					
					NSString *elementClassString = nil;
					if([elementTypeArray count] > 1) {
						NSString *prefix = [elementTypeArray objectAtIndex:0];
						NSString *localName = [elementTypeArray objectAtIndex:1];
						
						xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
						
						NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
						
						elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
					} else {
						elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
					}
					
					elementClass = NSClassFromString(elementClassString);
					xmlFree(instanceType);
				}
				
				id newChild = [elementClass deserializeNode:cur];
				
				self.OCRWebServiceAvailablePagesResult = newChild;
			}
		}
	}
}
/* NSCoder functions taken from: 
 * http://davedelong.com/blog/2009/04/13/aspect-oriented-programming-objective-c
 */
- (id) initWithCoder:(NSCoder *)decoder {
	if ([super respondsToSelector:@selector(initWithCoder:)] && ![self isKindOfClass:[super class]]) {
		self = [super performSelector:@selector(initWithCoder:) withObject:decoder];
	} else {
		self = [super init];
	}
	if (self == nil) { return nil; }
 
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	unsigned int numIvars = 0;
	Ivar * ivars = class_copyIvarList([self class], &numIvars);
	for(int i = 0; i < numIvars; i++) {
		Ivar thisIvar = ivars[i];
		NSString * key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
		id value = [decoder decodeObjectForKey:key];
		if (value == nil) { value = [NSNumber numberWithFloat:0.0]; }
		[self setValue:value forKey:key];
	}
	if (numIvars > 0) { free(ivars); }
	[pool drain];
	return self;
}
- (void) encodeWithCoder:(NSCoder *)encoder {
	if ([super respondsToSelector:@selector(encodeWithCoder:)] && ![self isKindOfClass:[super class]]) {
		[super performSelector:@selector(encodeWithCoder:) withObject:encoder];
	}
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	unsigned int numIvars = 0;
	Ivar * ivars = class_copyIvarList([self class], &numIvars);
	for (int i = 0; i < numIvars; i++) {
		Ivar thisIvar = ivars[i];
		NSString * key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
		id value = [self valueForKey:key];
		[encoder encodeObject:value forKey:key];
	}
	if (numIvars > 0) { free(ivars); }
	[pool drain];
}
@end
@implementation OCRWebServiceSvc
+ (void)initialize
{
	[[USGlobals sharedInstance].wsdlStandardNamespaces setObject:@"xsd" forKey:@"http://www.w3.org/2001/XMLSchema"];
	[[USGlobals sharedInstance].wsdlStandardNamespaces setObject:@"OCRWebServiceSvc" forKey:@"http://stockservice.contoso.com/wse/samples/2005/10"];
}
+ (OCRWebServiceSoapBinding *)OCRWebServiceSoapBinding
{
	return [[[OCRWebServiceSoapBinding alloc] initWithAddress:@"http://www.ocrwebservice.com/services/OCRWebService.asmx"] autorelease];
}
+ (OCRWebServiceSoap12Binding *)OCRWebServiceSoap12Binding
{
	return [[[OCRWebServiceSoap12Binding alloc] initWithAddress:@"http://www.ocrwebservice.com/services/OCRWebService.asmx"] autorelease];
}
@end
@implementation OCRWebServiceSoapBinding
@synthesize address;
@synthesize timeout;
@synthesize logXMLInOut;
@synthesize ignoreEmptyResponse;
@synthesize cookies;
@synthesize customHeaders;
@synthesize soapSigner;
@synthesize sslManager;
+ (NSTimeInterval)defaultTimeout
{
	return 10;
}
- (id)init
{
	if((self = [super init])) {
		address = nil;
		cookies = nil;
		customHeaders = [NSMutableDictionary new];
		timeout = [[self class] defaultTimeout];
		logXMLInOut = NO;
		synchronousOperationComplete = NO;
	}
	
	return self;
}
- (id)initWithAddress:(NSString *)anAddress
{
	if((self = [self init])) {
		self.address = [NSURL URLWithString:anAddress];
	}
	
	return self;
}
- (NSString *)MIMEType
{
	return @"text/xml";
}
- (void)addCookie:(NSHTTPCookie *)toAdd
{
	if(toAdd != nil) {
		if(cookies == nil) cookies = [[NSMutableArray alloc] init];
		[cookies addObject:toAdd];
	}
}
- (OCRWebServiceSoapBindingResponse *)performSynchronousOperation:(OCRWebServiceSoapBindingOperation *)operation
{
	synchronousOperationComplete = NO;
	[operation start];
	
	// Now wait for response
	NSRunLoop *theRL = [NSRunLoop currentRunLoop];
	
	while (!synchronousOperationComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
	return operation.response;
}
- (void)performAsynchronousOperation:(OCRWebServiceSoapBindingOperation *)operation
{
	[operation start];
}
- (void) operation:(OCRWebServiceSoapBindingOperation *)operation completedWithResponse:(OCRWebServiceSoapBindingResponse *)response
{
	synchronousOperationComplete = YES;
}
- (OCRWebServiceSoapBindingResponse *)OCRWebServiceRecognizeUsingParameters:(OCRWebServiceSvc_OCRWebServiceRecognize *)aParameters 
{
	return [self performSynchronousOperation:[[(OCRWebServiceSoapBinding_OCRWebServiceRecognize*)[OCRWebServiceSoapBinding_OCRWebServiceRecognize alloc] initWithBinding:self delegate:self
																							parameters:aParameters
																							] autorelease]];
}
- (void)OCRWebServiceRecognizeAsyncUsingParameters:(OCRWebServiceSvc_OCRWebServiceRecognize *)aParameters  delegate:(id<OCRWebServiceSoapBindingResponseDelegate>)responseDelegate
{
	[self performAsynchronousOperation: [[(OCRWebServiceSoapBinding_OCRWebServiceRecognize*)[OCRWebServiceSoapBinding_OCRWebServiceRecognize alloc] initWithBinding:self delegate:responseDelegate
																							 parameters:aParameters
																							 ] autorelease]];
}
- (OCRWebServiceSoapBindingResponse *)OCRWebServiceLogUsingParameters:(OCRWebServiceSvc_OCRWebServiceLog *)aParameters 
{
	return [self performSynchronousOperation:[[(OCRWebServiceSoapBinding_OCRWebServiceLog*)[OCRWebServiceSoapBinding_OCRWebServiceLog alloc] initWithBinding:self delegate:self
																							parameters:aParameters
																							] autorelease]];
}
- (void)OCRWebServiceLogAsyncUsingParameters:(OCRWebServiceSvc_OCRWebServiceLog *)aParameters  delegate:(id<OCRWebServiceSoapBindingResponseDelegate>)responseDelegate
{
	[self performAsynchronousOperation: [[(OCRWebServiceSoapBinding_OCRWebServiceLog*)[OCRWebServiceSoapBinding_OCRWebServiceLog alloc] initWithBinding:self delegate:responseDelegate
																							 parameters:aParameters
																							 ] autorelease]];
}
- (OCRWebServiceSoapBindingResponse *)OCRWebServiceAvailablePagesUsingParameters:(OCRWebServiceSvc_OCRWebServiceAvailablePages *)aParameters 
{
	return [self performSynchronousOperation:[[(OCRWebServiceSoapBinding_OCRWebServiceAvailablePages*)[OCRWebServiceSoapBinding_OCRWebServiceAvailablePages alloc] initWithBinding:self delegate:self
																							parameters:aParameters
																							] autorelease]];
}
- (void)OCRWebServiceAvailablePagesAsyncUsingParameters:(OCRWebServiceSvc_OCRWebServiceAvailablePages *)aParameters  delegate:(id<OCRWebServiceSoapBindingResponseDelegate>)responseDelegate
{
	[self performAsynchronousOperation: [[(OCRWebServiceSoapBinding_OCRWebServiceAvailablePages*)[OCRWebServiceSoapBinding_OCRWebServiceAvailablePages alloc] initWithBinding:self delegate:responseDelegate
																							 parameters:aParameters
																							 ] autorelease]];
}
- (void)sendHTTPCallUsingBody:(NSString *)outputBody soapAction:(NSString *)soapAction forOperation:(OCRWebServiceSoapBindingOperation *)operation
{
    if (!outputBody) {
        NSError * err = [NSError errorWithDomain:@"OCRWebServiceSoapBindingNULLRequestExcpetion"
                                            code:0
                                        userInfo:nil];
        
        [operation connection:nil didFailWithError:err];
        return;
    }
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.address 
																												 cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
																										 timeoutInterval:self.timeout];
	NSData *bodyData = [outputBody dataUsingEncoding:NSUTF8StringEncoding];
	
	if(cookies != nil) {
		[request setAllHTTPHeaderFields:[NSHTTPCookie requestHeaderFieldsWithCookies:cookies]];
	}
	[request setValue:@"wsdl2objc" forHTTPHeaderField:@"User-Agent"];
	[request setValue:soapAction forHTTPHeaderField:@"SOAPAction"];
	[request setValue:[[self MIMEType] stringByAppendingString:@"; charset=utf-8"] forHTTPHeaderField:@"Content-Type"];
	// ERICBE: cast to unsigned long to prevent warnings about implicit cast of NSInteger
	[request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) [bodyData length]] forHTTPHeaderField:@"Content-Length"];
	[request setValue:self.address.host forHTTPHeaderField:@"Host"];
	for (NSString *eachHeaderField in [self.customHeaders allKeys]) {
		[request setValue:[self.customHeaders objectForKey:eachHeaderField] forHTTPHeaderField:eachHeaderField];
	}
	[request setHTTPMethod: @"POST"];
	// set version 1.1 - how?
	[request setHTTPBody: bodyData];
		
	if(self.logXMLInOut) {
		NSLog(@"OutputHeaders:\n%@", [request allHTTPHeaderFields]);
		NSLog(@"OutputBody:\n%@", outputBody);
	}
	
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:operation];
	
	operation.urlConnection = connection;
	[connection release];
}
- (void) dealloc
{
	[soapSigner release];
	// ERICBE: Assign sslManager property to nil to release it - avoids a compiler warning.
	// [sslManager release];
	self.sslManager = nil;
	[address release];
	[cookies release];
	[customHeaders release];
	[super dealloc];
}
@end
@implementation OCRWebServiceSoapBindingOperation
@synthesize binding;
@synthesize response;
@synthesize delegate;
@synthesize responseData;
@synthesize urlConnection;
- (id)initWithBinding:(OCRWebServiceSoapBinding *)aBinding delegate:(id<OCRWebServiceSoapBindingResponseDelegate>)aDelegate
{
	if ((self = [super init])) {
		self.binding = aBinding;
		response = nil;
		self.delegate = aDelegate;
		self.responseData = nil;
		self.urlConnection = nil;
	}
	
	return self;
}
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [binding.sslManager canAuthenticateForAuthenticationMethod:protectionSpace.authenticationMethod];
}
-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	if (![binding.sslManager authenticateForChallenge:challenge]) {
		[[challenge sender] cancelAuthenticationChallenge:challenge];
	}
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)urlResponse
{
	NSHTTPURLResponse *httpResponse;
	if ([urlResponse isKindOfClass:[NSHTTPURLResponse class]]) {
		httpResponse = (NSHTTPURLResponse *) urlResponse;
	} else {
		httpResponse = nil;
	}
	
	if(self.binding.logXMLInOut) {
		NSLog(@"ResponseStatus: %ld\n", (long)[httpResponse statusCode]);
		NSLog(@"ResponseHeaders:\n%@", [httpResponse allHeaderFields]);
	}
    NSInteger contentLength = [[[httpResponse allHeaderFields] objectForKey:@"Content-Length"] integerValue];
	
	if ([urlResponse.MIMEType rangeOfString:[self.binding MIMEType]].length == 0) {
		if ((self.binding.ignoreEmptyResponse == NO) || (contentLength != 0)) {
			NSError *error = nil;
			[connection cancel];
			if ([httpResponse statusCode] >= 400) {
				NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]],NSLocalizedDescriptionKey,
																			  httpResponse.URL, NSURLErrorKey,nil];
				error = [NSError errorWithDomain:@"OCRWebServiceSoapBindingResponseHTTP" code:[httpResponse statusCode] userInfo:userInfo];
			} else {
				NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
														[NSString stringWithFormat: @"Unexpected response MIME type to SOAP call:%@", urlResponse.MIMEType],NSLocalizedDescriptionKey,
																			  httpResponse.URL, NSURLErrorKey,nil];
				error = [NSError errorWithDomain:@"OCRWebServiceSoapBindingResponseHTTP" code:1 userInfo:userInfo];
			}
				
			[self connection:connection didFailWithError:error];
		} else {
            [delegate operation:self completedWithResponse:response];
		}
	}
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	if (responseData == nil) {
		responseData = [data mutableCopy];
	} else {
		[responseData appendData:data];
	}
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	if (binding.logXMLInOut) {
		NSLog(@"ResponseError:\n%@", error);
	}
	response.error = error;
	[delegate operation:self completedWithResponse:response];
}
- (void)dealloc
{
	[binding release];
	[response release];
	delegate = nil;
	[responseData release];
	[urlConnection release];
	
	[super dealloc];
}
@end
@implementation OCRWebServiceSoapBinding_OCRWebServiceRecognize
@synthesize parameters;
- (id)initWithBinding:(OCRWebServiceSoapBinding *)aBinding delegate:(id<OCRWebServiceSoapBindingResponseDelegate>)responseDelegate
parameters:(OCRWebServiceSvc_OCRWebServiceRecognize *)aParameters
{
	if((self = [super initWithBinding:aBinding delegate:responseDelegate])) {
		self.parameters = aParameters;
	}
	
	return self;
}
- (void)dealloc
{
	if(parameters != nil) [parameters release];
	
	[super dealloc];
}
- (void)main
{
	[response autorelease];
	response = [OCRWebServiceSoapBindingResponse new];
	
	OCRWebServiceSoapBinding_envelope *envelope = [OCRWebServiceSoapBinding_envelope sharedInstance];
	
	NSMutableDictionary *headerElements = nil;
	headerElements = [NSMutableDictionary dictionary];
	
	NSMutableDictionary *bodyElements = nil;
	NSMutableArray *bodyKeys = nil;
	bodyElements = [NSMutableDictionary dictionary];
	bodyKeys = [NSMutableArray array];
	id obj = nil;
	if(parameters != nil) obj = parameters;
	if(obj != nil) {
		[bodyElements setObject:obj forKey:@"OCRWebServiceRecognize"];
		[bodyKeys addObject:@"OCRWebServiceRecognize"];
	}
	
	NSString *operationXMLString = [envelope serializedFormUsingHeaderElements:headerElements bodyElements:bodyElements bodyKeys:bodyKeys];
	operationXMLString = binding.soapSigner ? [binding.soapSigner signRequest:operationXMLString] : operationXMLString;
	
	[binding sendHTTPCallUsingBody:operationXMLString soapAction:@"http://stockservice.contoso.com/wse/samples/2005/10/OCRWebServiceRecognize" forOperation:self];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	if (responseData != nil && delegate != nil)
	{
		xmlDocPtr doc;
		xmlNodePtr cur;
		
		if (binding.logXMLInOut) {
			NSLog(@"ResponseBody:\n%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
		}
		
#if !TARGET_OS_IPHONE && (!defined(MAC_OS_X_VERSION_10_6) || MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_6)
	// Not yet defined in 10.5 libxml
	#define XML_PARSE_COMPACT 0
#endif
    // EricBe: Put explicit conversion since [responseData length] is NSInteger but xmlReadMemory wants int.
	doc = xmlReadMemory([responseData bytes], (int) [responseData length], NULL, NULL, XML_PARSE_COMPACT | XML_PARSE_NOBLANKS);
		
		if (doc == NULL) {
			NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Errors while parsing returned XML" forKey:NSLocalizedDescriptionKey];
			
			response.error = [NSError errorWithDomain:@"OCRWebServiceSoapBindingResponseXML" code:1 userInfo:userInfo];
			[delegate operation:self completedWithResponse:response];
		} else {
			cur = xmlDocGetRootElement(doc);
			cur = cur->children;
			
			for( ; cur != NULL ; cur = cur->next) {
				if(cur->type == XML_ELEMENT_NODE) {
					
					if(xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
						NSMutableArray *responseBodyParts = [NSMutableArray array];
						
						xmlNodePtr bodyNode;
						for(bodyNode=cur->children ; bodyNode != NULL ; bodyNode = bodyNode->next) {
							if(cur->type == XML_ELEMENT_NODE) {
								if(xmlStrEqual(bodyNode->name, (const xmlChar *) "OCRWebServiceRecognizeResponse")) {
									OCRWebServiceSvc_OCRWebServiceRecognizeResponse *bodyObject = [OCRWebServiceSvc_OCRWebServiceRecognizeResponse deserializeNode:bodyNode];
									//NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
									if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
								}
								if ((bodyNode->ns != nil && xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix)) && 
									xmlStrEqual(bodyNode->name, (const xmlChar *) "Fault")) {
                                    NSDictionary *exceptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                nil];
									SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode expectedExceptions:exceptions];
									//NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
									if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
								}
							}
						}
						
						response.bodyParts = responseBodyParts;
					}
				}
			}
			
			xmlFreeDoc(doc);
		}
		
		xmlCleanupParser();
		[delegate operation:self completedWithResponse:response];
	}
}
@end
@implementation OCRWebServiceSoapBinding_OCRWebServiceLog
@synthesize parameters;
- (id)initWithBinding:(OCRWebServiceSoapBinding *)aBinding delegate:(id<OCRWebServiceSoapBindingResponseDelegate>)responseDelegate
parameters:(OCRWebServiceSvc_OCRWebServiceLog *)aParameters
{
	if((self = [super initWithBinding:aBinding delegate:responseDelegate])) {
		self.parameters = aParameters;
	}
	
	return self;
}
- (void)dealloc
{
	if(parameters != nil) [parameters release];
	
	[super dealloc];
}
- (void)main
{
	[response autorelease];
	response = [OCRWebServiceSoapBindingResponse new];
	
	OCRWebServiceSoapBinding_envelope *envelope = [OCRWebServiceSoapBinding_envelope sharedInstance];
	
	NSMutableDictionary *headerElements = nil;
	headerElements = [NSMutableDictionary dictionary];
	
	NSMutableDictionary *bodyElements = nil;
	NSMutableArray *bodyKeys = nil;
	bodyElements = [NSMutableDictionary dictionary];
	bodyKeys = [NSMutableArray array];
	id obj = nil;
	if(parameters != nil) obj = parameters;
	if(obj != nil) {
		[bodyElements setObject:obj forKey:@"OCRWebServiceLog"];
		[bodyKeys addObject:@"OCRWebServiceLog"];
	}
	
	NSString *operationXMLString = [envelope serializedFormUsingHeaderElements:headerElements bodyElements:bodyElements bodyKeys:bodyKeys];
	operationXMLString = binding.soapSigner ? [binding.soapSigner signRequest:operationXMLString] : operationXMLString;
	
	[binding sendHTTPCallUsingBody:operationXMLString soapAction:@"http://stockservice.contoso.com/wse/samples/2005/10/OCRWebServiceLog" forOperation:self];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	if (responseData != nil && delegate != nil)
	{
		xmlDocPtr doc;
		xmlNodePtr cur;
		
		if (binding.logXMLInOut) {
			NSLog(@"ResponseBody:\n%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
		}
		
#if !TARGET_OS_IPHONE && (!defined(MAC_OS_X_VERSION_10_6) || MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_6)
	// Not yet defined in 10.5 libxml
	#define XML_PARSE_COMPACT 0
#endif
    // EricBe: Put explicit conversion since [responseData length] is NSInteger but xmlReadMemory wants int.
	doc = xmlReadMemory([responseData bytes], (int) [responseData length], NULL, NULL, XML_PARSE_COMPACT | XML_PARSE_NOBLANKS);
		
		if (doc == NULL) {
			NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Errors while parsing returned XML" forKey:NSLocalizedDescriptionKey];
			
			response.error = [NSError errorWithDomain:@"OCRWebServiceSoapBindingResponseXML" code:1 userInfo:userInfo];
			[delegate operation:self completedWithResponse:response];
		} else {
			cur = xmlDocGetRootElement(doc);
			cur = cur->children;
			
			for( ; cur != NULL ; cur = cur->next) {
				if(cur->type == XML_ELEMENT_NODE) {
					
					if(xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
						NSMutableArray *responseBodyParts = [NSMutableArray array];
						
						xmlNodePtr bodyNode;
						for(bodyNode=cur->children ; bodyNode != NULL ; bodyNode = bodyNode->next) {
							if(cur->type == XML_ELEMENT_NODE) {
								if(xmlStrEqual(bodyNode->name, (const xmlChar *) "OCRWebServiceLogResponse")) {
									OCRWebServiceSvc_OCRWebServiceLogResponse *bodyObject = [OCRWebServiceSvc_OCRWebServiceLogResponse deserializeNode:bodyNode];
									//NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
									if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
								}
								if ((bodyNode->ns != nil && xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix)) && 
									xmlStrEqual(bodyNode->name, (const xmlChar *) "Fault")) {
                                    NSDictionary *exceptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                nil];
									SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode expectedExceptions:exceptions];
									//NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
									if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
								}
							}
						}
						
						response.bodyParts = responseBodyParts;
					}
				}
			}
			
			xmlFreeDoc(doc);
		}
		
		xmlCleanupParser();
		[delegate operation:self completedWithResponse:response];
	}
}
@end
@implementation OCRWebServiceSoapBinding_OCRWebServiceAvailablePages
@synthesize parameters;
- (id)initWithBinding:(OCRWebServiceSoapBinding *)aBinding delegate:(id<OCRWebServiceSoapBindingResponseDelegate>)responseDelegate
parameters:(OCRWebServiceSvc_OCRWebServiceAvailablePages *)aParameters
{
	if((self = [super initWithBinding:aBinding delegate:responseDelegate])) {
		self.parameters = aParameters;
	}
	
	return self;
}
- (void)dealloc
{
	if(parameters != nil) [parameters release];
	
	[super dealloc];
}
- (void)main
{
	[response autorelease];
	response = [OCRWebServiceSoapBindingResponse new];
	
	OCRWebServiceSoapBinding_envelope *envelope = [OCRWebServiceSoapBinding_envelope sharedInstance];
	
	NSMutableDictionary *headerElements = nil;
	headerElements = [NSMutableDictionary dictionary];
	
	NSMutableDictionary *bodyElements = nil;
	NSMutableArray *bodyKeys = nil;
	bodyElements = [NSMutableDictionary dictionary];
	bodyKeys = [NSMutableArray array];
	id obj = nil;
	if(parameters != nil) obj = parameters;
	if(obj != nil) {
		[bodyElements setObject:obj forKey:@"OCRWebServiceAvailablePages"];
		[bodyKeys addObject:@"OCRWebServiceAvailablePages"];
	}
	
	NSString *operationXMLString = [envelope serializedFormUsingHeaderElements:headerElements bodyElements:bodyElements bodyKeys:bodyKeys];
	operationXMLString = binding.soapSigner ? [binding.soapSigner signRequest:operationXMLString] : operationXMLString;
	
	[binding sendHTTPCallUsingBody:operationXMLString soapAction:@"http://stockservice.contoso.com/wse/samples/2005/10/OCRWebServiceAvailablePages" forOperation:self];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	if (responseData != nil && delegate != nil)
	{
		xmlDocPtr doc;
		xmlNodePtr cur;
		
		if (binding.logXMLInOut) {
			NSLog(@"ResponseBody:\n%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
		}
		
#if !TARGET_OS_IPHONE && (!defined(MAC_OS_X_VERSION_10_6) || MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_6)
	// Not yet defined in 10.5 libxml
	#define XML_PARSE_COMPACT 0
#endif
    // EricBe: Put explicit conversion since [responseData length] is NSInteger but xmlReadMemory wants int.
	doc = xmlReadMemory([responseData bytes], (int) [responseData length], NULL, NULL, XML_PARSE_COMPACT | XML_PARSE_NOBLANKS);
		
		if (doc == NULL) {
			NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Errors while parsing returned XML" forKey:NSLocalizedDescriptionKey];
			
			response.error = [NSError errorWithDomain:@"OCRWebServiceSoapBindingResponseXML" code:1 userInfo:userInfo];
			[delegate operation:self completedWithResponse:response];
		} else {
			cur = xmlDocGetRootElement(doc);
			cur = cur->children;
			
			for( ; cur != NULL ; cur = cur->next) {
				if(cur->type == XML_ELEMENT_NODE) {
					
					if(xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
						NSMutableArray *responseBodyParts = [NSMutableArray array];
						
						xmlNodePtr bodyNode;
						for(bodyNode=cur->children ; bodyNode != NULL ; bodyNode = bodyNode->next) {
							if(cur->type == XML_ELEMENT_NODE) {
								if(xmlStrEqual(bodyNode->name, (const xmlChar *) "OCRWebServiceAvailablePagesResponse")) {
									OCRWebServiceSvc_OCRWebServiceAvailablePagesResponse *bodyObject = [OCRWebServiceSvc_OCRWebServiceAvailablePagesResponse deserializeNode:bodyNode];
									//NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
									if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
								}
								if ((bodyNode->ns != nil && xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix)) && 
									xmlStrEqual(bodyNode->name, (const xmlChar *) "Fault")) {
                                    NSDictionary *exceptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                nil];
									SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode expectedExceptions:exceptions];
									//NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
									if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
								}
							}
						}
						
						response.bodyParts = responseBodyParts;
					}
				}
			}
			
			xmlFreeDoc(doc);
		}
		
		xmlCleanupParser();
		[delegate operation:self completedWithResponse:response];
	}
}
@end
static OCRWebServiceSoapBinding_envelope *OCRWebServiceSoapBindingSharedEnvelopeInstance = nil;
@implementation OCRWebServiceSoapBinding_envelope
+ (OCRWebServiceSoapBinding_envelope *)sharedInstance
{
	if(OCRWebServiceSoapBindingSharedEnvelopeInstance == nil) {
		OCRWebServiceSoapBindingSharedEnvelopeInstance = [OCRWebServiceSoapBinding_envelope new];
	}
	
	return OCRWebServiceSoapBindingSharedEnvelopeInstance;
}
- (NSString *)serializedFormUsingHeaderElements:(NSDictionary *)headerElements bodyElements:(NSDictionary *)bodyElements bodyKeys:(NSArray *)bodyKeys
{
	xmlDocPtr doc;
	
	doc = xmlNewDoc((const xmlChar*)XML_DEFAULT_VERSION);
	if (doc == NULL) {
		NSLog(@"Error creating the xml document tree");
		return @"";
	}
	
	xmlNodePtr root = xmlNewDocNode(doc, NULL, (const xmlChar*)"Envelope", NULL);
	xmlDocSetRootElement(doc, root);
	
	xmlNsPtr soapEnvelopeNs = xmlNewNs(root, (const xmlChar*)"http://schemas.xmlsoap.org/soap/envelope/", (const xmlChar*)"soap");
	xmlSetNs(root, soapEnvelopeNs);
	
	xmlNsPtr xslNs = xmlNewNs(root, (const xmlChar*)"http://www.w3.org/1999/XSL/Transform", (const xmlChar*)"xsl");
	xmlNewNs(root, (const xmlChar*)"http://www.w3.org/2001/XMLSchema-instance", (const xmlChar*)"xsi");
	
	xmlNewNsProp(root, xslNs, (const xmlChar*)"version", (const xmlChar*)"1.0");
	
	xmlNewNs(root, (const xmlChar*)"http://www.w3.org/2001/XMLSchema", (const xmlChar*)"xsd");
	xmlNewNs(root, (const xmlChar*)"http://stockservice.contoso.com/wse/samples/2005/10", (const xmlChar*)"OCRWebServiceSvc");
	
	if((headerElements != nil) && ([headerElements count] > 0)) {
		xmlNodePtr headerNode = xmlNewDocNode(doc, soapEnvelopeNs, (const xmlChar*)"Header", NULL);
		xmlAddChild(root, headerNode);
		
		for(NSString *key in [headerElements allKeys]) {
			id header = [headerElements objectForKey:key];
			xmlAddChild(headerNode, [header xmlNodeForDoc:doc elementName:key elementNSPrefix:nil]);
		}
	}
	
	if((bodyElements != nil) && ([bodyElements count] > 0)) {
		xmlNodePtr bodyNode = xmlNewDocNode(doc, soapEnvelopeNs, (const xmlChar*)"Body", NULL);
		xmlAddChild(root, bodyNode);
		
		for(NSString *key in bodyKeys) {
			id body = [bodyElements objectForKey:key];
			xmlAddChild(bodyNode, [body xmlNodeForDoc:doc elementName:key elementNSPrefix:nil]);
		}
	}
	
	xmlChar *buf;
	int size;
	xmlDocDumpFormatMemory(doc, &buf, &size, 1);
	
	NSString *serializedForm = [NSString stringWithCString:(const char*)buf encoding:NSUTF8StringEncoding];
	xmlFree(buf);
	
	xmlFreeDoc(doc);	
	return serializedForm;
}
@end
@implementation OCRWebServiceSoapBindingResponse
@synthesize headers;
@synthesize bodyParts;
@synthesize error;
- (id)init
{
	if((self = [super init])) {
		headers = nil;
		bodyParts = nil;
		error = nil;
	}
	
	return self;
}
- (void)dealloc {
	self.headers = nil;
	self.bodyParts = nil;
	self.error = nil;	
	[super dealloc];
}
@end
@implementation OCRWebServiceSoap12Binding
@synthesize address;
@synthesize timeout;
@synthesize logXMLInOut;
@synthesize ignoreEmptyResponse;
@synthesize cookies;
@synthesize customHeaders;
@synthesize soapSigner;
@synthesize sslManager;
+ (NSTimeInterval)defaultTimeout
{
	return 10;
}
- (id)init
{
	if((self = [super init])) {
		address = nil;
		cookies = nil;
		customHeaders = [NSMutableDictionary new];
		timeout = [[self class] defaultTimeout];
		logXMLInOut = NO;
		synchronousOperationComplete = NO;
	}
	
	return self;
}
- (id)initWithAddress:(NSString *)anAddress
{
	if((self = [self init])) {
		self.address = [NSURL URLWithString:anAddress];
	}
	
	return self;
}
- (NSString *)MIMEType
{
	return @"application/soap+xml";
}
- (void)addCookie:(NSHTTPCookie *)toAdd
{
	if(toAdd != nil) {
		if(cookies == nil) cookies = [[NSMutableArray alloc] init];
		[cookies addObject:toAdd];
	}
}
- (OCRWebServiceSoap12BindingResponse *)performSynchronousOperation:(OCRWebServiceSoap12BindingOperation *)operation
{
	synchronousOperationComplete = NO;
	[operation start];
	
	// Now wait for response
	NSRunLoop *theRL = [NSRunLoop currentRunLoop];
	
	while (!synchronousOperationComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
	return operation.response;
}
- (void)performAsynchronousOperation:(OCRWebServiceSoap12BindingOperation *)operation
{
	[operation start];
}
- (void) operation:(OCRWebServiceSoap12BindingOperation *)operation completedWithResponse:(OCRWebServiceSoap12BindingResponse *)response
{
	synchronousOperationComplete = YES;
}
- (OCRWebServiceSoap12BindingResponse *)OCRWebServiceRecognizeUsingParameters:(OCRWebServiceSvc_OCRWebServiceRecognize *)aParameters 
{
	return [self performSynchronousOperation:[[(OCRWebServiceSoap12Binding_OCRWebServiceRecognize*)[OCRWebServiceSoap12Binding_OCRWebServiceRecognize alloc] initWithBinding:self delegate:self
																							parameters:aParameters
																							] autorelease]];
}
- (void)OCRWebServiceRecognizeAsyncUsingParameters:(OCRWebServiceSvc_OCRWebServiceRecognize *)aParameters  delegate:(id<OCRWebServiceSoap12BindingResponseDelegate>)responseDelegate
{
	[self performAsynchronousOperation: [[(OCRWebServiceSoap12Binding_OCRWebServiceRecognize*)[OCRWebServiceSoap12Binding_OCRWebServiceRecognize alloc] initWithBinding:self delegate:responseDelegate
																							 parameters:aParameters
																							 ] autorelease]];
}
- (OCRWebServiceSoap12BindingResponse *)OCRWebServiceLogUsingParameters:(OCRWebServiceSvc_OCRWebServiceLog *)aParameters 
{
	return [self performSynchronousOperation:[[(OCRWebServiceSoap12Binding_OCRWebServiceLog*)[OCRWebServiceSoap12Binding_OCRWebServiceLog alloc] initWithBinding:self delegate:self
																							parameters:aParameters
																							] autorelease]];
}
- (void)OCRWebServiceLogAsyncUsingParameters:(OCRWebServiceSvc_OCRWebServiceLog *)aParameters  delegate:(id<OCRWebServiceSoap12BindingResponseDelegate>)responseDelegate
{
	[self performAsynchronousOperation: [[(OCRWebServiceSoap12Binding_OCRWebServiceLog*)[OCRWebServiceSoap12Binding_OCRWebServiceLog alloc] initWithBinding:self delegate:responseDelegate
																							 parameters:aParameters
																							 ] autorelease]];
}
- (OCRWebServiceSoap12BindingResponse *)OCRWebServiceAvailablePagesUsingParameters:(OCRWebServiceSvc_OCRWebServiceAvailablePages *)aParameters 
{
	return [self performSynchronousOperation:[[(OCRWebServiceSoap12Binding_OCRWebServiceAvailablePages*)[OCRWebServiceSoap12Binding_OCRWebServiceAvailablePages alloc] initWithBinding:self delegate:self
																							parameters:aParameters
																							] autorelease]];
}
- (void)OCRWebServiceAvailablePagesAsyncUsingParameters:(OCRWebServiceSvc_OCRWebServiceAvailablePages *)aParameters  delegate:(id<OCRWebServiceSoap12BindingResponseDelegate>)responseDelegate
{
	[self performAsynchronousOperation: [[(OCRWebServiceSoap12Binding_OCRWebServiceAvailablePages*)[OCRWebServiceSoap12Binding_OCRWebServiceAvailablePages alloc] initWithBinding:self delegate:responseDelegate
																							 parameters:aParameters
																							 ] autorelease]];
}
- (void)sendHTTPCallUsingBody:(NSString *)outputBody soapAction:(NSString *)soapAction forOperation:(OCRWebServiceSoap12BindingOperation *)operation
{
    if (!outputBody) {
        NSError * err = [NSError errorWithDomain:@"OCRWebServiceSoap12BindingNULLRequestExcpetion"
                                            code:0
                                        userInfo:nil];
        
        [operation connection:nil didFailWithError:err];
        return;
    }
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.address 
																												 cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
																										 timeoutInterval:self.timeout];
	NSData *bodyData = [outputBody dataUsingEncoding:NSUTF8StringEncoding];
	
	if(cookies != nil) {
		[request setAllHTTPHeaderFields:[NSHTTPCookie requestHeaderFieldsWithCookies:cookies]];
	}
	[request setValue:@"wsdl2objc" forHTTPHeaderField:@"User-Agent"];
	[request setValue:soapAction forHTTPHeaderField:@"SOAPAction"];
	[request setValue:[[self MIMEType] stringByAppendingString:@"; charset=utf-8"] forHTTPHeaderField:@"Content-Type"];
	// ERICBE: cast to unsigned long to prevent warnings about implicit cast of NSInteger
	[request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) [bodyData length]] forHTTPHeaderField:@"Content-Length"];
	[request setValue:self.address.host forHTTPHeaderField:@"Host"];
	for (NSString *eachHeaderField in [self.customHeaders allKeys]) {
		[request setValue:[self.customHeaders objectForKey:eachHeaderField] forHTTPHeaderField:eachHeaderField];
	}
	[request setHTTPMethod: @"POST"];
	// set version 1.1 - how?
	[request setHTTPBody: bodyData];
		
	if(self.logXMLInOut) {
		NSLog(@"OutputHeaders:\n%@", [request allHTTPHeaderFields]);
		NSLog(@"OutputBody:\n%@", outputBody);
	}
	
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:operation];
	
	operation.urlConnection = connection;
	[connection release];
}
- (void) dealloc
{
	[soapSigner release];
	// ERICBE: Assign sslManager property to nil to release it - avoids a compiler warning.
	// [sslManager release];
	self.sslManager = nil;
	[address release];
	[cookies release];
	[customHeaders release];
	[super dealloc];
}
@end
@implementation OCRWebServiceSoap12BindingOperation
@synthesize binding;
@synthesize response;
@synthesize delegate;
@synthesize responseData;
@synthesize urlConnection;
- (id)initWithBinding:(OCRWebServiceSoap12Binding *)aBinding delegate:(id<OCRWebServiceSoap12BindingResponseDelegate>)aDelegate
{
	if ((self = [super init])) {
		self.binding = aBinding;
		response = nil;
		self.delegate = aDelegate;
		self.responseData = nil;
		self.urlConnection = nil;
	}
	
	return self;
}
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [binding.sslManager canAuthenticateForAuthenticationMethod:protectionSpace.authenticationMethod];
}
-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	if (![binding.sslManager authenticateForChallenge:challenge]) {
		[[challenge sender] cancelAuthenticationChallenge:challenge];
	}
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)urlResponse
{
	NSHTTPURLResponse *httpResponse;
	if ([urlResponse isKindOfClass:[NSHTTPURLResponse class]]) {
		httpResponse = (NSHTTPURLResponse *) urlResponse;
	} else {
		httpResponse = nil;
	}
	
	if(self.binding.logXMLInOut) {
		NSLog(@"ResponseStatus: %ld\n", (long)[httpResponse statusCode]);
		NSLog(@"ResponseHeaders:\n%@", [httpResponse allHeaderFields]);
	}
    NSInteger contentLength = [[[httpResponse allHeaderFields] objectForKey:@"Content-Length"] integerValue];
	
	if ([urlResponse.MIMEType rangeOfString:[self.binding MIMEType]].length == 0) {
		if ((self.binding.ignoreEmptyResponse == NO) || (contentLength != 0)) {
			NSError *error = nil;
			[connection cancel];
			if ([httpResponse statusCode] >= 400) {
				NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]],NSLocalizedDescriptionKey,
																			  httpResponse.URL, NSURLErrorKey,nil];
				error = [NSError errorWithDomain:@"OCRWebServiceSoap12BindingResponseHTTP" code:[httpResponse statusCode] userInfo:userInfo];
			} else {
				NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
														[NSString stringWithFormat: @"Unexpected response MIME type to SOAP call:%@", urlResponse.MIMEType],NSLocalizedDescriptionKey,
																			  httpResponse.URL, NSURLErrorKey,nil];
				error = [NSError errorWithDomain:@"OCRWebServiceSoap12BindingResponseHTTP" code:1 userInfo:userInfo];
			}
				
			[self connection:connection didFailWithError:error];
		} else {
            [delegate operation:self completedWithResponse:response];
		}
	}
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	if (responseData == nil) {
		responseData = [data mutableCopy];
	} else {
		[responseData appendData:data];
	}
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	if (binding.logXMLInOut) {
		NSLog(@"ResponseError:\n%@", error);
	}
	response.error = error;
	[delegate operation:self completedWithResponse:response];
}
- (void)dealloc
{
	[binding release];
	[response release];
	delegate = nil;
	[responseData release];
	[urlConnection release];
	
	[super dealloc];
}
@end
@implementation OCRWebServiceSoap12Binding_OCRWebServiceRecognize
@synthesize parameters;
- (id)initWithBinding:(OCRWebServiceSoap12Binding *)aBinding delegate:(id<OCRWebServiceSoap12BindingResponseDelegate>)responseDelegate
parameters:(OCRWebServiceSvc_OCRWebServiceRecognize *)aParameters
{
	if((self = [super initWithBinding:aBinding delegate:responseDelegate])) {
		self.parameters = aParameters;
	}
	
	return self;
}
- (void)dealloc
{
	if(parameters != nil) [parameters release];
	
	[super dealloc];
}
- (void)main
{
	[response autorelease];
	response = [OCRWebServiceSoap12BindingResponse new];
	
	OCRWebServiceSoap12Binding_envelope *envelope = [OCRWebServiceSoap12Binding_envelope sharedInstance];
	
	NSMutableDictionary *headerElements = nil;
	headerElements = [NSMutableDictionary dictionary];
	
	NSMutableDictionary *bodyElements = nil;
	NSMutableArray *bodyKeys = nil;
	bodyElements = [NSMutableDictionary dictionary];
	bodyKeys = [NSMutableArray array];
	id obj = nil;
	if(parameters != nil) obj = parameters;
	if(obj != nil) {
		[bodyElements setObject:obj forKey:@"OCRWebServiceRecognize"];
		[bodyKeys addObject:@"OCRWebServiceRecognize"];
	}
	
	NSString *operationXMLString = [envelope serializedFormUsingHeaderElements:headerElements bodyElements:bodyElements bodyKeys:bodyKeys];
	operationXMLString = binding.soapSigner ? [binding.soapSigner signRequest:operationXMLString] : operationXMLString;
	
	[binding sendHTTPCallUsingBody:operationXMLString soapAction:@"http://stockservice.contoso.com/wse/samples/2005/10/OCRWebServiceRecognize" forOperation:self];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	if (responseData != nil && delegate != nil)
	{
		xmlDocPtr doc;
		xmlNodePtr cur;
		
		if (binding.logXMLInOut) {
			NSLog(@"ResponseBody:\n%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
		}
		
#if !TARGET_OS_IPHONE && (!defined(MAC_OS_X_VERSION_10_6) || MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_6)
	// Not yet defined in 10.5 libxml
	#define XML_PARSE_COMPACT 0
#endif
    // EricBe: Put explicit conversion since [responseData length] is NSInteger but xmlReadMemory wants int.
	doc = xmlReadMemory([responseData bytes], (int) [responseData length], NULL, NULL, XML_PARSE_COMPACT | XML_PARSE_NOBLANKS);
		
		if (doc == NULL) {
			NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Errors while parsing returned XML" forKey:NSLocalizedDescriptionKey];
			
			response.error = [NSError errorWithDomain:@"OCRWebServiceSoap12BindingResponseXML" code:1 userInfo:userInfo];
			[delegate operation:self completedWithResponse:response];
		} else {
			cur = xmlDocGetRootElement(doc);
			cur = cur->children;
			
			for( ; cur != NULL ; cur = cur->next) {
				if(cur->type == XML_ELEMENT_NODE) {
					
					if(xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
						NSMutableArray *responseBodyParts = [NSMutableArray array];
						
						xmlNodePtr bodyNode;
						for(bodyNode=cur->children ; bodyNode != NULL ; bodyNode = bodyNode->next) {
							if(cur->type == XML_ELEMENT_NODE) {
								if(xmlStrEqual(bodyNode->name, (const xmlChar *) "OCRWebServiceRecognizeResponse")) {
									OCRWebServiceSvc_OCRWebServiceRecognizeResponse *bodyObject = [OCRWebServiceSvc_OCRWebServiceRecognizeResponse deserializeNode:bodyNode];
									//NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
									if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
								}
								if ((bodyNode->ns != nil && xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix)) && 
									xmlStrEqual(bodyNode->name, (const xmlChar *) "Fault")) {
                                    NSDictionary *exceptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                nil];
									SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode expectedExceptions:exceptions];
									//NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
									if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
								}
							}
						}
						
						response.bodyParts = responseBodyParts;
					}
				}
			}
			
			xmlFreeDoc(doc);
		}
		
		xmlCleanupParser();
		[delegate operation:self completedWithResponse:response];
	}
}
@end
@implementation OCRWebServiceSoap12Binding_OCRWebServiceLog
@synthesize parameters;
- (id)initWithBinding:(OCRWebServiceSoap12Binding *)aBinding delegate:(id<OCRWebServiceSoap12BindingResponseDelegate>)responseDelegate
parameters:(OCRWebServiceSvc_OCRWebServiceLog *)aParameters
{
	if((self = [super initWithBinding:aBinding delegate:responseDelegate])) {
		self.parameters = aParameters;
	}
	
	return self;
}
- (void)dealloc
{
	if(parameters != nil) [parameters release];
	
	[super dealloc];
}
- (void)main
{
	[response autorelease];
	response = [OCRWebServiceSoap12BindingResponse new];
	
	OCRWebServiceSoap12Binding_envelope *envelope = [OCRWebServiceSoap12Binding_envelope sharedInstance];
	
	NSMutableDictionary *headerElements = nil;
	headerElements = [NSMutableDictionary dictionary];
	
	NSMutableDictionary *bodyElements = nil;
	NSMutableArray *bodyKeys = nil;
	bodyElements = [NSMutableDictionary dictionary];
	bodyKeys = [NSMutableArray array];
	id obj = nil;
	if(parameters != nil) obj = parameters;
	if(obj != nil) {
		[bodyElements setObject:obj forKey:@"OCRWebServiceLog"];
		[bodyKeys addObject:@"OCRWebServiceLog"];
	}
	
	NSString *operationXMLString = [envelope serializedFormUsingHeaderElements:headerElements bodyElements:bodyElements bodyKeys:bodyKeys];
	operationXMLString = binding.soapSigner ? [binding.soapSigner signRequest:operationXMLString] : operationXMLString;
	
	[binding sendHTTPCallUsingBody:operationXMLString soapAction:@"http://stockservice.contoso.com/wse/samples/2005/10/OCRWebServiceLog" forOperation:self];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	if (responseData != nil && delegate != nil)
	{
		xmlDocPtr doc;
		xmlNodePtr cur;
		
		if (binding.logXMLInOut) {
			NSLog(@"ResponseBody:\n%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
		}
		
#if !TARGET_OS_IPHONE && (!defined(MAC_OS_X_VERSION_10_6) || MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_6)
	// Not yet defined in 10.5 libxml
	#define XML_PARSE_COMPACT 0
#endif
    // EricBe: Put explicit conversion since [responseData length] is NSInteger but xmlReadMemory wants int.
	doc = xmlReadMemory([responseData bytes], (int) [responseData length], NULL, NULL, XML_PARSE_COMPACT | XML_PARSE_NOBLANKS);
		
		if (doc == NULL) {
			NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Errors while parsing returned XML" forKey:NSLocalizedDescriptionKey];
			
			response.error = [NSError errorWithDomain:@"OCRWebServiceSoap12BindingResponseXML" code:1 userInfo:userInfo];
			[delegate operation:self completedWithResponse:response];
		} else {
			cur = xmlDocGetRootElement(doc);
			cur = cur->children;
			
			for( ; cur != NULL ; cur = cur->next) {
				if(cur->type == XML_ELEMENT_NODE) {
					
					if(xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
						NSMutableArray *responseBodyParts = [NSMutableArray array];
						
						xmlNodePtr bodyNode;
						for(bodyNode=cur->children ; bodyNode != NULL ; bodyNode = bodyNode->next) {
							if(cur->type == XML_ELEMENT_NODE) {
								if(xmlStrEqual(bodyNode->name, (const xmlChar *) "OCRWebServiceLogResponse")) {
									OCRWebServiceSvc_OCRWebServiceLogResponse *bodyObject = [OCRWebServiceSvc_OCRWebServiceLogResponse deserializeNode:bodyNode];
									//NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
									if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
								}
								if ((bodyNode->ns != nil && xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix)) && 
									xmlStrEqual(bodyNode->name, (const xmlChar *) "Fault")) {
                                    NSDictionary *exceptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                nil];
									SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode expectedExceptions:exceptions];
									//NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
									if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
								}
							}
						}
						
						response.bodyParts = responseBodyParts;
					}
				}
			}
			
			xmlFreeDoc(doc);
		}
		
		xmlCleanupParser();
		[delegate operation:self completedWithResponse:response];
	}
}
@end
@implementation OCRWebServiceSoap12Binding_OCRWebServiceAvailablePages
@synthesize parameters;
- (id)initWithBinding:(OCRWebServiceSoap12Binding *)aBinding delegate:(id<OCRWebServiceSoap12BindingResponseDelegate>)responseDelegate
parameters:(OCRWebServiceSvc_OCRWebServiceAvailablePages *)aParameters
{
	if((self = [super initWithBinding:aBinding delegate:responseDelegate])) {
		self.parameters = aParameters;
	}
	
	return self;
}
- (void)dealloc
{
	if(parameters != nil) [parameters release];
	
	[super dealloc];
}
- (void)main
{
	[response autorelease];
	response = [OCRWebServiceSoap12BindingResponse new];
	
	OCRWebServiceSoap12Binding_envelope *envelope = [OCRWebServiceSoap12Binding_envelope sharedInstance];
	
	NSMutableDictionary *headerElements = nil;
	headerElements = [NSMutableDictionary dictionary];
	
	NSMutableDictionary *bodyElements = nil;
	NSMutableArray *bodyKeys = nil;
	bodyElements = [NSMutableDictionary dictionary];
	bodyKeys = [NSMutableArray array];
	id obj = nil;
	if(parameters != nil) obj = parameters;
	if(obj != nil) {
		[bodyElements setObject:obj forKey:@"OCRWebServiceAvailablePages"];
		[bodyKeys addObject:@"OCRWebServiceAvailablePages"];
	}
	
	NSString *operationXMLString = [envelope serializedFormUsingHeaderElements:headerElements bodyElements:bodyElements bodyKeys:bodyKeys];
	operationXMLString = binding.soapSigner ? [binding.soapSigner signRequest:operationXMLString] : operationXMLString;
	
	[binding sendHTTPCallUsingBody:operationXMLString soapAction:@"http://stockservice.contoso.com/wse/samples/2005/10/OCRWebServiceAvailablePages" forOperation:self];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	if (responseData != nil && delegate != nil)
	{
		xmlDocPtr doc;
		xmlNodePtr cur;
		
		if (binding.logXMLInOut) {
			NSLog(@"ResponseBody:\n%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
		}
		
#if !TARGET_OS_IPHONE && (!defined(MAC_OS_X_VERSION_10_6) || MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_6)
	// Not yet defined in 10.5 libxml
	#define XML_PARSE_COMPACT 0
#endif
    // EricBe: Put explicit conversion since [responseData length] is NSInteger but xmlReadMemory wants int.
	doc = xmlReadMemory([responseData bytes], (int) [responseData length], NULL, NULL, XML_PARSE_COMPACT | XML_PARSE_NOBLANKS);
		
		if (doc == NULL) {
			NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Errors while parsing returned XML" forKey:NSLocalizedDescriptionKey];
			
			response.error = [NSError errorWithDomain:@"OCRWebServiceSoap12BindingResponseXML" code:1 userInfo:userInfo];
			[delegate operation:self completedWithResponse:response];
		} else {
			cur = xmlDocGetRootElement(doc);
			cur = cur->children;
			
			for( ; cur != NULL ; cur = cur->next) {
				if(cur->type == XML_ELEMENT_NODE) {
					
					if(xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
						NSMutableArray *responseBodyParts = [NSMutableArray array];
						
						xmlNodePtr bodyNode;
						for(bodyNode=cur->children ; bodyNode != NULL ; bodyNode = bodyNode->next) {
							if(cur->type == XML_ELEMENT_NODE) {
								if(xmlStrEqual(bodyNode->name, (const xmlChar *) "OCRWebServiceAvailablePagesResponse")) {
									OCRWebServiceSvc_OCRWebServiceAvailablePagesResponse *bodyObject = [OCRWebServiceSvc_OCRWebServiceAvailablePagesResponse deserializeNode:bodyNode];
									//NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
									if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
								}
								if ((bodyNode->ns != nil && xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix)) && 
									xmlStrEqual(bodyNode->name, (const xmlChar *) "Fault")) {
                                    NSDictionary *exceptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                nil];
									SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode expectedExceptions:exceptions];
									//NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
									if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
								}
							}
						}
						
						response.bodyParts = responseBodyParts;
					}
				}
			}
			
			xmlFreeDoc(doc);
		}
		
		xmlCleanupParser();
		[delegate operation:self completedWithResponse:response];
	}
}
@end
static OCRWebServiceSoap12Binding_envelope *OCRWebServiceSoap12BindingSharedEnvelopeInstance = nil;
@implementation OCRWebServiceSoap12Binding_envelope
+ (OCRWebServiceSoap12Binding_envelope *)sharedInstance
{
	if(OCRWebServiceSoap12BindingSharedEnvelopeInstance == nil) {
		OCRWebServiceSoap12BindingSharedEnvelopeInstance = [OCRWebServiceSoap12Binding_envelope new];
	}
	
	return OCRWebServiceSoap12BindingSharedEnvelopeInstance;
}
- (NSString *)serializedFormUsingHeaderElements:(NSDictionary *)headerElements bodyElements:(NSDictionary *)bodyElements bodyKeys:(NSArray *)bodyKeys
{
	xmlDocPtr doc;
	
	doc = xmlNewDoc((const xmlChar*)XML_DEFAULT_VERSION);
	if (doc == NULL) {
		NSLog(@"Error creating the xml document tree");
		return @"";
	}
	
	xmlNodePtr root = xmlNewDocNode(doc, NULL, (const xmlChar*)"Envelope", NULL);
	xmlDocSetRootElement(doc, root);
	
	xmlNsPtr soapEnvelopeNs = xmlNewNs(root, (const xmlChar*)"http://www.w3.org/2003/05/soap-envelope", (const xmlChar*)"soap");
	xmlSetNs(root, soapEnvelopeNs);
	
	xmlNsPtr xslNs = xmlNewNs(root, (const xmlChar*)"http://www.w3.org/1999/XSL/Transform", (const xmlChar*)"xsl");
	xmlNewNs(root, (const xmlChar*)"http://www.w3.org/2001/XMLSchema-instance", (const xmlChar*)"xsi");
	
	xmlNewNsProp(root, xslNs, (const xmlChar*)"version", (const xmlChar*)"1.0");
	
	xmlNewNs(root, (const xmlChar*)"http://www.w3.org/2001/XMLSchema", (const xmlChar*)"xsd");
	xmlNewNs(root, (const xmlChar*)"http://stockservice.contoso.com/wse/samples/2005/10", (const xmlChar*)"OCRWebServiceSvc");
	
	if((headerElements != nil) && ([headerElements count] > 0)) {
		xmlNodePtr headerNode = xmlNewDocNode(doc, soapEnvelopeNs, (const xmlChar*)"Header", NULL);
		xmlAddChild(root, headerNode);
		
		for(NSString *key in [headerElements allKeys]) {
			id header = [headerElements objectForKey:key];
			xmlAddChild(headerNode, [header xmlNodeForDoc:doc elementName:key elementNSPrefix:nil]);
		}
	}
	
	if((bodyElements != nil) && ([bodyElements count] > 0)) {
		xmlNodePtr bodyNode = xmlNewDocNode(doc, soapEnvelopeNs, (const xmlChar*)"Body", NULL);
		xmlAddChild(root, bodyNode);
		
		for(NSString *key in bodyKeys) {
			id body = [bodyElements objectForKey:key];
			xmlAddChild(bodyNode, [body xmlNodeForDoc:doc elementName:key elementNSPrefix:nil]);
		}
	}
	
	xmlChar *buf;
	int size;
	xmlDocDumpFormatMemory(doc, &buf, &size, 1);
	
	NSString *serializedForm = [NSString stringWithCString:(const char*)buf encoding:NSUTF8StringEncoding];
	xmlFree(buf);
	
	xmlFreeDoc(doc);	
	return serializedForm;
}
@end
@implementation OCRWebServiceSoap12BindingResponse
@synthesize headers;
@synthesize bodyParts;
@synthesize error;
- (id)init
{
	if((self = [super init])) {
		headers = nil;
		bodyParts = nil;
		error = nil;
	}
	
	return self;
}
- (void)dealloc {
	self.headers = nil;
	self.bodyParts = nil;
	self.error = nil;	
	[super dealloc];
}
@end
