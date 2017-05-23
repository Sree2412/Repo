angular.module("ELS")
  .directive("attachmentList", function() {
    return {
      scope: {
        attachments: '=',
      },
      templateUrl: 'attachments.html',
      controller: function( $scope ) {
        $scope.attachmentIcons = {
          "File": "save",
          "Note": "note",
          "Ticket": "help",
        }

        $scope.showAttachmentDetail = function( attachment ) {
          $scope.detailAttachment = attachment;
        }

        $scope.addAttachment = function( type ) {
          var attachment = { type: type };
          if( !$scope.attachments ) {
            $scope.attachments = [];
          }

          $scope.attachments.push( attachment );
          $scope.showAttachmentDetail( attachment );
        }
      },
    }
  })
  .directive("attachmentDetail", function() {
    return {
      scope: {
        attachment: '=',
      },
      templateUrl: 'attachment-detail.html',
    }
  })
