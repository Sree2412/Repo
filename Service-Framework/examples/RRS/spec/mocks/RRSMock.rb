module RRSMock
    GetClientComment = '{
        "Id":65351,
        "RecordRetentionScheduleItemId":114,
        "DomainCommentTypeId":3,
        "ClientVisibleFlag":false,
        "RRSReportVisibleFlag":false,
        "CommentText":"Comment 11",
        "DeletedFlag":false,
        "CreatedDate":"2016-02-12T03:22:22.3209743-06:00",
        "CreatedBy":"HURONCONSULTING\bushman",
        "UpdatedDate":null,
        "UpdatedBy":null
    }'
    
	AddClientComment = '{
		"RecordRetentionScheduleItemId":114,
		"CommentText":"Comment 11",
		"DomainCommentTypeId":3,
		"CreatedBy":"HURONCONSULTING\bushman"
	}'
	
	UpdateClientComment = '{
		"Id":65351,
		"RecordRetentionScheduleItemId":114,
		"CommentText":"Comment NewCommentUpdate"
	}'
end