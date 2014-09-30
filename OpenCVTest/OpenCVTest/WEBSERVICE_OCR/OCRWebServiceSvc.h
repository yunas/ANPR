#import <Foundation/Foundation.h>
#import "USAdditions.h"
#import <libxml/tree.h>
#import "USGlobals.h"
#import <objc/runtime.h>
@class OCRWebServiceSvc_OCRWebServiceRecognize;
@class OCRWebServiceSvc_OCRWSInputImage;
@class OCRWebServiceSvc_OCRWSSettings;
@class OCRWebServiceSvc_ArrayOfOCRWSZone;
@class OCRWebServiceSvc_OCRWSZone;
@class OCRWebServiceSvc_OCRWebServiceRecognizeResponse;
@class OCRWebServiceSvc_OCRWSResponse;
@class OCRWebServiceSvc_ArrayOfArrayOfString;
@class OCRWebServiceSvc_ArrayOfArrayOfOCRWSWord;
@class OCRWebServiceSvc_ArrayOfString;
@class OCRWebServiceSvc_ArrayOfOCRWSWord;
@class OCRWebServiceSvc_OCRWSWord;
@class OCRWebServiceSvc_OCRWebServiceLog;
@class OCRWebServiceSvc_OCRWebServiceLogResponse;
@class OCRWebServiceSvc_OCRWebServiceAvailablePages;
@class OCRWebServiceSvc_OCRWebServiceAvailablePagesResponse;
@interface OCRWebServiceSvc_OCRWSInputImage : NSObject <NSCoding> {
SOAPSigner *soapSigner;
/* elements */
	NSString * fileName;
	NSData * fileData;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (OCRWebServiceSvc_OCRWSInputImage *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (retain) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, retain) NSString * fileName;
@property (nonatomic, retain) NSData * fileData;
/* attributes */
- (NSDictionary *)attributes;
@end
typedef enum {
	OCRWebServiceSvc_OCRWS_Language_none = 0,
	OCRWebServiceSvc_OCRWS_Language_BRAZILIAN,
	OCRWebServiceSvc_OCRWS_Language_BYELORUSSIAN,
	OCRWebServiceSvc_OCRWS_Language_BULGARIAN,
	OCRWebServiceSvc_OCRWS_Language_CATALAN,
	OCRWebServiceSvc_OCRWS_Language_CROATIAN,
	OCRWebServiceSvc_OCRWS_Language_CZECH,
	OCRWebServiceSvc_OCRWS_Language_DANISH,
	OCRWebServiceSvc_OCRWS_Language_DUTCH,
	OCRWebServiceSvc_OCRWS_Language_ENGLISH,
	OCRWebServiceSvc_OCRWS_Language_ESTONIAN,
	OCRWebServiceSvc_OCRWS_Language_FINNISH,
	OCRWebServiceSvc_OCRWS_Language_FRENCH,
	OCRWebServiceSvc_OCRWS_Language_GERMAN,
	OCRWebServiceSvc_OCRWS_Language_GREEK,
	OCRWebServiceSvc_OCRWS_Language_HUNGARIAN,
	OCRWebServiceSvc_OCRWS_Language_INDONESIAN,
	OCRWebServiceSvc_OCRWS_Language_ITALIAN,
	OCRWebServiceSvc_OCRWS_Language_LATIN,
	OCRWebServiceSvc_OCRWS_Language_LATVIAN,
	OCRWebServiceSvc_OCRWS_Language_LITHUANIAN,
	OCRWebServiceSvc_OCRWS_Language_MOLDAVIAN,
	OCRWebServiceSvc_OCRWS_Language_POLISH,
	OCRWebServiceSvc_OCRWS_Language_PORTUGUESE,
	OCRWebServiceSvc_OCRWS_Language_ROMANIAN,
	OCRWebServiceSvc_OCRWS_Language_RUSSIAN,
	OCRWebServiceSvc_OCRWS_Language_SERBIAN,
	OCRWebServiceSvc_OCRWS_Language_SLOVAKIAN,
	OCRWebServiceSvc_OCRWS_Language_SLOVENIAN,
	OCRWebServiceSvc_OCRWS_Language_SPANISH,
	OCRWebServiceSvc_OCRWS_Language_SWEDISH,
	OCRWebServiceSvc_OCRWS_Language_TURKISH,
	OCRWebServiceSvc_OCRWS_Language_UKRAINIAN,
	OCRWebServiceSvc_OCRWS_Language_JAPANESE,
	OCRWebServiceSvc_OCRWS_Language_CHINESESIMPLIFIED,
	OCRWebServiceSvc_OCRWS_Language_CHINESETRADITIONAL,
	OCRWebServiceSvc_OCRWS_Language_KOREAN,
} OCRWebServiceSvc_OCRWS_Language;
OCRWebServiceSvc_OCRWS_Language OCRWebServiceSvc_OCRWS_Language_enumFromString(NSString *string);
NSString * OCRWebServiceSvc_OCRWS_Language_stringFromEnum(OCRWebServiceSvc_OCRWS_Language enumValue);
typedef enum {
	OCRWebServiceSvc_OCRWS_OutputFormat_none = 0,
	OCRWebServiceSvc_OCRWS_OutputFormat_DOC,
	OCRWebServiceSvc_OCRWS_OutputFormat_PDF,
	OCRWebServiceSvc_OCRWS_OutputFormat_EXCEL,
	OCRWebServiceSvc_OCRWS_OutputFormat_HTML,
	OCRWebServiceSvc_OCRWS_OutputFormat_TXT,
	OCRWebServiceSvc_OCRWS_OutputFormat_RTF,
	OCRWebServiceSvc_OCRWS_OutputFormat_PDFIMGTEXT,
} OCRWebServiceSvc_OCRWS_OutputFormat;
OCRWebServiceSvc_OCRWS_OutputFormat OCRWebServiceSvc_OCRWS_OutputFormat_enumFromString(NSString *string);
NSString * OCRWebServiceSvc_OCRWS_OutputFormat_stringFromEnum(OCRWebServiceSvc_OCRWS_OutputFormat enumValue);
@interface OCRWebServiceSvc_OCRWSZone : NSObject <NSCoding> {
SOAPSigner *soapSigner;
/* elements */
	NSNumber * Top;
	NSNumber * Left;
	NSNumber * Height;
	NSNumber * Width;
	NSNumber * ZoneType;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (OCRWebServiceSvc_OCRWSZone *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (retain) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, retain) NSNumber * Top;
@property (nonatomic, retain) NSNumber * Left;
@property (nonatomic, retain) NSNumber * Height;
@property (nonatomic, retain) NSNumber * Width;
@property (nonatomic, retain) NSNumber * ZoneType;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface OCRWebServiceSvc_ArrayOfOCRWSZone : NSObject <NSCoding> {
SOAPSigner *soapSigner;
/* elements */
	NSMutableArray *OCRWSZone;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (OCRWebServiceSvc_ArrayOfOCRWSZone *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (retain) SOAPSigner *soapSigner;
/* elements */
- (void)addOCRWSZone:(OCRWebServiceSvc_OCRWSZone *)toAdd;
@property (nonatomic, readonly) NSMutableArray * OCRWSZone;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface OCRWebServiceSvc_OCRWSSettings : NSObject <NSCoding> {
SOAPSigner *soapSigner;
/* elements */
	NSMutableArray *ocrLanguages;
	OCRWebServiceSvc_OCRWS_OutputFormat outputDocumentFormat;
	USBoolean * convertToBW;
	USBoolean * getOCRText;
	USBoolean * createOutputDocument;
	USBoolean * multiPageDoc;
	NSString * pageNumbers;
	OCRWebServiceSvc_ArrayOfOCRWSZone * ocrZones;
	USBoolean * ocrWords;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (OCRWebServiceSvc_OCRWSSettings *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (retain) SOAPSigner *soapSigner;
/* elements */
- (void)addOcrLanguages:(OCRWebServiceSvc_OCRWS_Language)toAdd;
@property (nonatomic, readonly) NSMutableArray * ocrLanguages;
@property (nonatomic, assign) OCRWebServiceSvc_OCRWS_OutputFormat outputDocumentFormat;
@property (nonatomic, retain) USBoolean * convertToBW;
@property (nonatomic, retain) USBoolean * getOCRText;
@property (nonatomic, retain) USBoolean * createOutputDocument;
@property (nonatomic, retain) USBoolean * multiPageDoc;
@property (nonatomic, retain) NSString * pageNumbers;
@property (nonatomic, retain) OCRWebServiceSvc_ArrayOfOCRWSZone * ocrZones;
@property (nonatomic, retain) USBoolean * ocrWords;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface OCRWebServiceSvc_OCRWebServiceRecognize : NSObject <NSCoding> {
SOAPSigner *soapSigner;
/* elements */
	NSString * user_name;
	NSString * license_code;
	OCRWebServiceSvc_OCRWSInputImage * OCRWSInputImage;
	OCRWebServiceSvc_OCRWSSettings * OCRWSSetting;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (OCRWebServiceSvc_OCRWebServiceRecognize *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (retain) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, retain) NSString * user_name;
@property (nonatomic, retain) NSString * license_code;
@property (nonatomic, retain) OCRWebServiceSvc_OCRWSInputImage * OCRWSInputImage;
@property (nonatomic, retain) OCRWebServiceSvc_OCRWSSettings * OCRWSSetting;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface OCRWebServiceSvc_ArrayOfString : NSObject <NSCoding> {
SOAPSigner *soapSigner;
/* elements */
	NSMutableArray *string;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (OCRWebServiceSvc_ArrayOfString *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (retain) SOAPSigner *soapSigner;
/* elements */
- (void)addString:(NSString *)toAdd;
@property (nonatomic, readonly) NSMutableArray * string;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface OCRWebServiceSvc_ArrayOfArrayOfString : NSObject <NSCoding> {
SOAPSigner *soapSigner;
/* elements */
	NSMutableArray *ArrayOfString;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (OCRWebServiceSvc_ArrayOfArrayOfString *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (retain) SOAPSigner *soapSigner;
/* elements */
- (void)addArrayOfString:(OCRWebServiceSvc_ArrayOfString *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ArrayOfString;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface OCRWebServiceSvc_OCRWSWord : NSObject <NSCoding> {
SOAPSigner *soapSigner;
/* elements */
	NSNumber * Top;
	NSNumber * Left;
	NSNumber * Height;
	NSNumber * Width;
	NSString * OCRWord;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (OCRWebServiceSvc_OCRWSWord *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (retain) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, retain) NSNumber * Top;
@property (nonatomic, retain) NSNumber * Left;
@property (nonatomic, retain) NSNumber * Height;
@property (nonatomic, retain) NSNumber * Width;
@property (nonatomic, retain) NSString * OCRWord;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface OCRWebServiceSvc_ArrayOfOCRWSWord : NSObject <NSCoding> {
SOAPSigner *soapSigner;
/* elements */
	NSMutableArray *OCRWSWord;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (OCRWebServiceSvc_ArrayOfOCRWSWord *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (retain) SOAPSigner *soapSigner;
/* elements */
- (void)addOCRWSWord:(OCRWebServiceSvc_OCRWSWord *)toAdd;
@property (nonatomic, readonly) NSMutableArray * OCRWSWord;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface OCRWebServiceSvc_ArrayOfArrayOfOCRWSWord : NSObject <NSCoding> {
SOAPSigner *soapSigner;
/* elements */
	NSMutableArray *ArrayOfOCRWSWord;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (OCRWebServiceSvc_ArrayOfArrayOfOCRWSWord *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (retain) SOAPSigner *soapSigner;
/* elements */
- (void)addArrayOfOCRWSWord:(OCRWebServiceSvc_ArrayOfOCRWSWord *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ArrayOfOCRWSWord;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface OCRWebServiceSvc_OCRWSResponse : NSObject <NSCoding> {
SOAPSigner *soapSigner;
/* elements */
	OCRWebServiceSvc_ArrayOfArrayOfString * ocrText;
	NSString * fileName;
	NSData * fileData;
	NSString * errorMessage;
	OCRWebServiceSvc_ArrayOfArrayOfOCRWSWord * ocrWSWords;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (OCRWebServiceSvc_OCRWSResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (retain) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, retain) OCRWebServiceSvc_ArrayOfArrayOfString * ocrText;
@property (nonatomic, retain) NSString * fileName;
@property (nonatomic, retain) NSData * fileData;
@property (nonatomic, retain) NSString * errorMessage;
@property (nonatomic, retain) OCRWebServiceSvc_ArrayOfArrayOfOCRWSWord * ocrWSWords;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface OCRWebServiceSvc_OCRWebServiceRecognizeResponse : NSObject <NSCoding> {
SOAPSigner *soapSigner;
/* elements */
	OCRWebServiceSvc_OCRWSResponse * OCRWSResponse;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (OCRWebServiceSvc_OCRWebServiceRecognizeResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (retain) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, retain) OCRWebServiceSvc_OCRWSResponse * OCRWSResponse;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface OCRWebServiceSvc_OCRWebServiceLog : NSObject <NSCoding> {
SOAPSigner *soapSigner;
/* elements */
	NSString * user_name;
	NSString * license_code;
	NSString * from_date;
	NSString * to_date;
	OCRWebServiceSvc_ArrayOfString * reserved;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (OCRWebServiceSvc_OCRWebServiceLog *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (retain) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, retain) NSString * user_name;
@property (nonatomic, retain) NSString * license_code;
@property (nonatomic, retain) NSString * from_date;
@property (nonatomic, retain) NSString * to_date;
@property (nonatomic, retain) OCRWebServiceSvc_ArrayOfString * reserved;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface OCRWebServiceSvc_OCRWebServiceLogResponse : NSObject <NSCoding> {
SOAPSigner *soapSigner;
/* elements */
	NSString * OCRWebServiceLogResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (OCRWebServiceSvc_OCRWebServiceLogResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (retain) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, retain) NSString * OCRWebServiceLogResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface OCRWebServiceSvc_OCRWebServiceAvailablePages : NSObject <NSCoding> {
SOAPSigner *soapSigner;
/* elements */
	NSString * user_name;
	NSString * license_code;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (OCRWebServiceSvc_OCRWebServiceAvailablePages *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (retain) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, retain) NSString * user_name;
@property (nonatomic, retain) NSString * license_code;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface OCRWebServiceSvc_OCRWebServiceAvailablePagesResponse : NSObject <NSCoding> {
SOAPSigner *soapSigner;
/* elements */
	NSNumber * OCRWebServiceAvailablePagesResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (OCRWebServiceSvc_OCRWebServiceAvailablePagesResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (retain) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, retain) NSNumber * OCRWebServiceAvailablePagesResult;
/* attributes */
- (NSDictionary *)attributes;
@end
/* Cookies handling provided by http://en.wikibooks.org/wiki/Programming:WebObjects/Web_Services/Web_Service_Provider */
#import <libxml/parser.h>
#import "xsd.h"
#import "OCRWebServiceSvc.h"
@class OCRWebServiceSoapBinding;
@class OCRWebServiceSoap12Binding;
@interface OCRWebServiceSvc : NSObject {
	
}
+ (OCRWebServiceSoapBinding *)OCRWebServiceSoapBinding;
+ (OCRWebServiceSoap12Binding *)OCRWebServiceSoap12Binding;
@end
@class OCRWebServiceSoapBindingResponse;
@class OCRWebServiceSoapBindingOperation;
@protocol OCRWebServiceSoapBindingResponseDelegate <NSObject>
- (void) operation:(OCRWebServiceSoapBindingOperation *)operation completedWithResponse:(OCRWebServiceSoapBindingResponse *)response;
@end
#define kServerAnchorCertificates   @"kServerAnchorCertificates"
#define kServerAnchorsOnly          @"kServerAnchorsOnly"
#define kClientIdentity             @"kClientIdentity"
#define kClientCertificates         @"kClientCertificates"
#define kClientUsername             @"kClientUsername"
#define kClientPassword             @"kClientPassword"
#define kNSURLCredentialPersistence @"kNSURLCredentialPersistence"
#define kValidateResult             @"kValidateResult"
@interface OCRWebServiceSoapBinding : NSObject <OCRWebServiceSoapBindingResponseDelegate> {
	NSURL *address;
	NSTimeInterval timeout;
	NSMutableArray *cookies;
	NSMutableDictionary *customHeaders;
	BOOL logXMLInOut;
	BOOL ignoreEmptyResponse;
	BOOL synchronousOperationComplete;
	id<SSLCredentialsManaging> sslManager;
	SOAPSigner *soapSigner;
}
@property (nonatomic, copy) NSURL *address;
@property (nonatomic) BOOL logXMLInOut;
@property (nonatomic) BOOL ignoreEmptyResponse;
@property (nonatomic) NSTimeInterval timeout;
@property (nonatomic, retain) NSMutableArray *cookies;
@property (nonatomic, retain) NSMutableDictionary *customHeaders;
@property (nonatomic, retain) id<SSLCredentialsManaging> sslManager;
@property (nonatomic, retain) SOAPSigner *soapSigner;
+ (NSTimeInterval) defaultTimeout;
- (id)initWithAddress:(NSString *)anAddress;
- (void)sendHTTPCallUsingBody:(NSString *)body soapAction:(NSString *)soapAction forOperation:(OCRWebServiceSoapBindingOperation *)operation;
- (void)addCookie:(NSHTTPCookie *)toAdd;
- (NSString *)MIMEType;
- (OCRWebServiceSoapBindingResponse *)OCRWebServiceRecognizeUsingParameters:(OCRWebServiceSvc_OCRWebServiceRecognize *)aParameters ;
- (void)OCRWebServiceRecognizeAsyncUsingParameters:(OCRWebServiceSvc_OCRWebServiceRecognize *)aParameters  delegate:(id<OCRWebServiceSoapBindingResponseDelegate>)responseDelegate;
- (OCRWebServiceSoapBindingResponse *)OCRWebServiceLogUsingParameters:(OCRWebServiceSvc_OCRWebServiceLog *)aParameters ;
- (void)OCRWebServiceLogAsyncUsingParameters:(OCRWebServiceSvc_OCRWebServiceLog *)aParameters  delegate:(id<OCRWebServiceSoapBindingResponseDelegate>)responseDelegate;
- (OCRWebServiceSoapBindingResponse *)OCRWebServiceAvailablePagesUsingParameters:(OCRWebServiceSvc_OCRWebServiceAvailablePages *)aParameters ;
- (void)OCRWebServiceAvailablePagesAsyncUsingParameters:(OCRWebServiceSvc_OCRWebServiceAvailablePages *)aParameters  delegate:(id<OCRWebServiceSoapBindingResponseDelegate>)responseDelegate;
@end
@interface OCRWebServiceSoapBindingOperation : NSOperation {
	OCRWebServiceSoapBinding *binding;
	OCRWebServiceSoapBindingResponse *response;
	id<OCRWebServiceSoapBindingResponseDelegate> delegate;
	NSMutableData *responseData;
	NSURLConnection *urlConnection;
}
@property (nonatomic, retain) OCRWebServiceSoapBinding *binding;
@property (nonatomic, readonly) OCRWebServiceSoapBindingResponse *response;
@property (nonatomic, assign) id<OCRWebServiceSoapBindingResponseDelegate> delegate;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) NSURLConnection *urlConnection;
- (id)initWithBinding:(OCRWebServiceSoapBinding *)aBinding delegate:(id<OCRWebServiceSoapBindingResponseDelegate>)aDelegate;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
@end
@interface OCRWebServiceSoapBinding_OCRWebServiceRecognize : OCRWebServiceSoapBindingOperation {
	OCRWebServiceSvc_OCRWebServiceRecognize * parameters;
}
@property (nonatomic, retain) OCRWebServiceSvc_OCRWebServiceRecognize * parameters;
- (id)initWithBinding:(OCRWebServiceSoapBinding *)aBinding delegate:(id<OCRWebServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(OCRWebServiceSvc_OCRWebServiceRecognize *)aParameters
;
@end
@interface OCRWebServiceSoapBinding_OCRWebServiceLog : OCRWebServiceSoapBindingOperation {
	OCRWebServiceSvc_OCRWebServiceLog * parameters;
}
@property (nonatomic, retain) OCRWebServiceSvc_OCRWebServiceLog * parameters;
- (id)initWithBinding:(OCRWebServiceSoapBinding *)aBinding delegate:(id<OCRWebServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(OCRWebServiceSvc_OCRWebServiceLog *)aParameters
;
@end
@interface OCRWebServiceSoapBinding_OCRWebServiceAvailablePages : OCRWebServiceSoapBindingOperation {
	OCRWebServiceSvc_OCRWebServiceAvailablePages * parameters;
}
@property (nonatomic, retain) OCRWebServiceSvc_OCRWebServiceAvailablePages * parameters;
- (id)initWithBinding:(OCRWebServiceSoapBinding *)aBinding delegate:(id<OCRWebServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(OCRWebServiceSvc_OCRWebServiceAvailablePages *)aParameters
;
@end
@interface OCRWebServiceSoapBinding_envelope : NSObject {
}
+ (OCRWebServiceSoapBinding_envelope *)sharedInstance;
- (NSString *)serializedFormUsingHeaderElements:(NSDictionary *)headerElements bodyElements:(NSDictionary *)bodyElements bodyKeys:(NSArray *)bodyKeys;
@end
@interface OCRWebServiceSoapBindingResponse : NSObject {
	NSArray *headers;
	NSArray *bodyParts;
	NSError *error;
}
@property (nonatomic, retain) NSArray *headers;
@property (nonatomic, retain) NSArray *bodyParts;
@property (nonatomic, retain) NSError *error;
@end
@class OCRWebServiceSoap12BindingResponse;
@class OCRWebServiceSoap12BindingOperation;
@protocol OCRWebServiceSoap12BindingResponseDelegate <NSObject>
- (void) operation:(OCRWebServiceSoap12BindingOperation *)operation completedWithResponse:(OCRWebServiceSoap12BindingResponse *)response;
@end
#define kServerAnchorCertificates   @"kServerAnchorCertificates"
#define kServerAnchorsOnly          @"kServerAnchorsOnly"
#define kClientIdentity             @"kClientIdentity"
#define kClientCertificates         @"kClientCertificates"
#define kClientUsername             @"kClientUsername"
#define kClientPassword             @"kClientPassword"
#define kNSURLCredentialPersistence @"kNSURLCredentialPersistence"
#define kValidateResult             @"kValidateResult"
@interface OCRWebServiceSoap12Binding : NSObject <OCRWebServiceSoap12BindingResponseDelegate> {
	NSURL *address;
	NSTimeInterval timeout;
	NSMutableArray *cookies;
	NSMutableDictionary *customHeaders;
	BOOL logXMLInOut;
	BOOL ignoreEmptyResponse;
	BOOL synchronousOperationComplete;
	id<SSLCredentialsManaging> sslManager;
	SOAPSigner *soapSigner;
}
@property (nonatomic, copy) NSURL *address;
@property (nonatomic) BOOL logXMLInOut;
@property (nonatomic) BOOL ignoreEmptyResponse;
@property (nonatomic) NSTimeInterval timeout;
@property (nonatomic, retain) NSMutableArray *cookies;
@property (nonatomic, retain) NSMutableDictionary *customHeaders;
@property (nonatomic, retain) id<SSLCredentialsManaging> sslManager;
@property (nonatomic, retain) SOAPSigner *soapSigner;
+ (NSTimeInterval) defaultTimeout;
- (id)initWithAddress:(NSString *)anAddress;
- (void)sendHTTPCallUsingBody:(NSString *)body soapAction:(NSString *)soapAction forOperation:(OCRWebServiceSoap12BindingOperation *)operation;
- (void)addCookie:(NSHTTPCookie *)toAdd;
- (NSString *)MIMEType;
- (OCRWebServiceSoap12BindingResponse *)OCRWebServiceRecognizeUsingParameters:(OCRWebServiceSvc_OCRWebServiceRecognize *)aParameters ;
- (void)OCRWebServiceRecognizeAsyncUsingParameters:(OCRWebServiceSvc_OCRWebServiceRecognize *)aParameters  delegate:(id<OCRWebServiceSoap12BindingResponseDelegate>)responseDelegate;
- (OCRWebServiceSoap12BindingResponse *)OCRWebServiceLogUsingParameters:(OCRWebServiceSvc_OCRWebServiceLog *)aParameters ;
- (void)OCRWebServiceLogAsyncUsingParameters:(OCRWebServiceSvc_OCRWebServiceLog *)aParameters  delegate:(id<OCRWebServiceSoap12BindingResponseDelegate>)responseDelegate;
- (OCRWebServiceSoap12BindingResponse *)OCRWebServiceAvailablePagesUsingParameters:(OCRWebServiceSvc_OCRWebServiceAvailablePages *)aParameters ;
- (void)OCRWebServiceAvailablePagesAsyncUsingParameters:(OCRWebServiceSvc_OCRWebServiceAvailablePages *)aParameters  delegate:(id<OCRWebServiceSoap12BindingResponseDelegate>)responseDelegate;
@end
@interface OCRWebServiceSoap12BindingOperation : NSOperation {
	OCRWebServiceSoap12Binding *binding;
	OCRWebServiceSoap12BindingResponse *response;
	id<OCRWebServiceSoap12BindingResponseDelegate> delegate;
	NSMutableData *responseData;
	NSURLConnection *urlConnection;
}
@property (nonatomic, retain) OCRWebServiceSoap12Binding *binding;
@property (nonatomic, readonly) OCRWebServiceSoap12BindingResponse *response;
@property (nonatomic, assign) id<OCRWebServiceSoap12BindingResponseDelegate> delegate;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) NSURLConnection *urlConnection;
- (id)initWithBinding:(OCRWebServiceSoap12Binding *)aBinding delegate:(id<OCRWebServiceSoap12BindingResponseDelegate>)aDelegate;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
@end
@interface OCRWebServiceSoap12Binding_OCRWebServiceRecognize : OCRWebServiceSoap12BindingOperation {
	OCRWebServiceSvc_OCRWebServiceRecognize * parameters;
}
@property (nonatomic, retain) OCRWebServiceSvc_OCRWebServiceRecognize * parameters;
- (id)initWithBinding:(OCRWebServiceSoap12Binding *)aBinding delegate:(id<OCRWebServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(OCRWebServiceSvc_OCRWebServiceRecognize *)aParameters
;
@end
@interface OCRWebServiceSoap12Binding_OCRWebServiceLog : OCRWebServiceSoap12BindingOperation {
	OCRWebServiceSvc_OCRWebServiceLog * parameters;
}
@property (nonatomic, retain) OCRWebServiceSvc_OCRWebServiceLog * parameters;
- (id)initWithBinding:(OCRWebServiceSoap12Binding *)aBinding delegate:(id<OCRWebServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(OCRWebServiceSvc_OCRWebServiceLog *)aParameters
;
@end
@interface OCRWebServiceSoap12Binding_OCRWebServiceAvailablePages : OCRWebServiceSoap12BindingOperation {
	OCRWebServiceSvc_OCRWebServiceAvailablePages * parameters;
}
@property (nonatomic, retain) OCRWebServiceSvc_OCRWebServiceAvailablePages * parameters;
- (id)initWithBinding:(OCRWebServiceSoap12Binding *)aBinding delegate:(id<OCRWebServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(OCRWebServiceSvc_OCRWebServiceAvailablePages *)aParameters
;
@end
@interface OCRWebServiceSoap12Binding_envelope : NSObject {
}
+ (OCRWebServiceSoap12Binding_envelope *)sharedInstance;
- (NSString *)serializedFormUsingHeaderElements:(NSDictionary *)headerElements bodyElements:(NSDictionary *)bodyElements bodyKeys:(NSArray *)bodyKeys;
@end
@interface OCRWebServiceSoap12BindingResponse : NSObject {
	NSArray *headers;
	NSArray *bodyParts;
	NSError *error;
}
@property (nonatomic, retain) NSArray *headers;
@property (nonatomic, retain) NSArray *bodyParts;
@property (nonatomic, retain) NSError *error;
@end
