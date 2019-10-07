public class RF_Chatter_NewLead_Controller {
    public string body { get; set; }
    public string userID { get; set; }

    @InvocableMethod(label='Post message' description='Post message with new Lead')
    public static void postFeed(List<Lead> lead){
        for(Lead l: lead) {
            ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

            ConnectApi.EntityLinkSegmentInput entityLinkSegmentLeadOwner = new ConnectApi.EntityLinkSegmentInput();
            entityLinkSegmentLeadOwner.entityId = l.OwnerId;
            messageBodyInput.messageSegments.add(entityLinkSegmentLeadOwner);

            ConnectApi.TextSegmentInput textSegmentInput1 = new ConnectApi.TextSegmentInput();
            textSegmentInput1.text = ' has created new Lead (';
            messageBodyInput.messageSegments.add(textSegmentInput1);

            ConnectApi.EntityLinkSegmentInput entityLinkSegmentLead = new ConnectApi.EntityLinkSegmentInput();
            entityLinkSegmentLead.entityId = l.Id;
            messageBodyInput.messageSegments.add(entityLinkSegmentLead);

            ConnectApi.TextSegmentInput textSegmentInput2 = new ConnectApi.TextSegmentInput();
            textSegmentInput2.text = ')';
            messageBodyInput.messageSegments.add(textSegmentInput2);

            feedItemInput.body = messageBodyInput;
            feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
            feedItemInput.subjectId = l.Id;

            ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
        }
    }
}