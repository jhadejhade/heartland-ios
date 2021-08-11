#import "HpsTerminalResponse.h"
#import "HpsHpaSharedParams.h"
#import <Heartland_iOS_SDK/Heartland_iOS_SDK-Swift.h>

@implementation HpsTerminalResponse

- (BOOL)gmsResponseIsApproval {
    NSString *approvalCode = self.gmsResponseIsFromGateway ? @"Success" : @"APPROVAL";
    return ([self.deviceResponseCode isEqualToString:approvalCode]
            || (self.gmsResponseIsReversal
                && self.gmsResponseOriginalTransactionInvalid));
}

- (BOOL)gmsResponseIsFromGateway {
    return self.gmsResponseIsReturn;
}

- (BOOL)gmsResponseIsReturn {
    return [self.transactionType isEqualToString:@"Return"];
}

- (BOOL)gmsResponseIsReversal {
    return [self.transactionType isEqualToString:@"Reversal"];
}

- (BOOL)gmsResponseIsReversible {
    return ([self.deviceResponseCode isEqualToString:@"hostTimeout"]
            && !self.gmsResponseIsReversal
            && self.clientTransactionIdUUID);
}

- (BOOL)gmsResponseOriginalTransactionInvalid {
    return [self.deviceResponseCode containsString:
            @"Transaction rejected because the referenced original transaction is invalid"];
}

- (void) mapResponse:(id <HpaResposeInterface>) response
{
	self.version = response.Version;
	self.status = response.MultipleMessage;
	self.responseText = response.Response;
	NSMutableDictionary *paramDictionary = [HpsHpaSharedParams getInstance].params;
	self.terminalSerialNumber = paramDictionary[@"TERMINAL INFORMATION"][@"SERIAL NUMBER"];
	if (response.ResponseId) {
		self.transactionId =  response.ResponseId;
	}
	else{
		self.transactionId =  response.TransactionId;

	}
    self.lastResponseTransactionId = [HpsHpaSharedParams getInstance].lastResponse.ResponseId;
    
}

@end
