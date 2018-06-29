#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "SignalR.h"
#import "SRHubConnection.h"
#import "SRHubConnectionInterface.h"
#import "SRHubInvocation.h"
#import "SRHubProxy.h"
#import "SRHubProxyInterface.h"
#import "SRHubRegistrationData.h"
#import "SRHubResult.h"
#import "SRHubs.h"
#import "SRSubscription.h"
#import "NSObject+SRJSON.h"
#import "SRDeserializable.h"
#import "SRExceptionHelper.h"
#import "SRSerializable.h"
#import "SRVersion.h"
#import "SRConnection.h"
#import "SRConnectionDelegate.h"
#import "SRConnectionExtensions.h"
#import "SRConnectionInterface.h"
#import "SRConnectionState.h"
#import "SRHeartbeatMonitor.h"
#import "SRKeepAliveData.h"
#import "SRLog.h"
#import "SRNegotiationResponse.h"
#import "SRChunkBuffer.h"
#import "SREventSourceRequestSerializer.h"
#import "SREventSourceResponseSerializer.h"
#import "SREventSourceStreamReader.h"
#import "SRServerSentEvent.h"
#import "SRAutoTransport.h"
#import "SRClientTransportInterface.h"
#import "SRHttpBasedTransport.h"
#import "SRLongPollingTransport.h"
#import "SRServerSentEventsTransport.h"
#import "SRWebSocketTransport.h"
#import "SRWebSocketConnectionInfo.h"

FOUNDATION_EXPORT double SignalR_ObjCVersionNumber;
FOUNDATION_EXPORT const unsigned char SignalR_ObjCVersionString[];

