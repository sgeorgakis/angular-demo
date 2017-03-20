var app = angular.module('messageTable', ['messageFilters']);

app.controller('messageControler', function ($scope, $http) {

    $scope.sortBy = 'date';
    $scope.sortReverse = true;
    $scope.currentPage = 0;
    $scope.pageSize = 5;
    $scope.selectedMessage = null;
    // $scope.inputStartDate = $("#inputStartDate").datepicker("getDate");
    // $scope.inputEndDate = $("#inputEndDate").datepicker("getDate");

    var date = new Date();
    var defaultSearchDate = new Date(date);
    defaultSearchDate.setMonth(date.getMonth() - 5);

    var msisdn = "306973046941";
    var startDate = defaultSearchDate.restFormat();
    var endDate = date.restFormat();
    var type = "message";
    var url = "http://localhost:8081/info?";
    var resendUrl = "http://localhost:8081/sendSms"
    var data = null;
    var error = false;

    var getMessages = function() {
        $http.get(messageUrl)
            .then(function (response) {
                if (response.data.length > 0) {
                    $scope.messages = response.data;
                    $scope.containsData = true;
                    $scope.totalPages = Math.ceil(response.data.length / $scope.pageSize);
                } else {
                    $scope.defaultMessage = "No messages found within the selected criteria";
                    $scope.containsData = false;
                }
            }, function (response) {
                $scope.errorMessage = "Something went wrong: " + response.data;
                $scope.containsData = false;
                $scope.error = true;
            })
    }

    var messageUrl = url;
    if (type != null) {
        messageUrl += "type=" + type;
    }
    if (msisdn != null) {
        messageUrl += "&msisdn=" + msisdn;
    }
    if (startDate != null) {
        messageUrl += "&date=" + startDate;
    }
    if (endDate != null) {
        messageUrl += "&endDate=" + endDate;
    }

    getMessages();

    $scope.sortFunction = function (sortByValue) {
        if ($scope.sortBy == sortByValue) {
            $scope.sortReverse = !$scope.sortReverse;
        } else {
            $scope.sortReverse = false;
        }
    }

    $scope.selectPage = function (index) {
        $scope.currentPage = index;
    }

    $scope.resend = function (message) {
        $http.post(resendUrl, message)
            .then(function(response) {
                window.alert("SMS Successfully resent to " + message.msisdn);
                getMessages();
            }, function (response) {
                window.alert(response.data);
            });
    }

    $scope.setPage = function (page) {
        if (page < 0 || page > $scope.totalPages) {
            return;
        }
        $scope.currentPage = page;
    }

    $scope.pageRange = function (arrayLength) {
        $scope.totalPages = Math.ceil(arrayLength / $scope.pageSize);
        var rangeToReturn = [];
        for (var i = 0; i < $scope.totalPages; i++) {
            rangeToReturn.push(i);
        }
        return rangeToReturn;
    }

    $scope.isSelected = function(message) {
        if (message.campaignNodePart != null) {
            $http.get(url + "type=campaign&data=" + message.campaignNodePart)
                .then(function (response) {
                    if (response.data.length > 0) {
                        $scope.selectedMessage = {
                            description: response.data[0].description,
                            dateStart: response.data[0].dateBegin,
                            dateEnd: response.data[0].dateEnd,
                            duration: response.data[0].duration,
                            date: message.date,
                            text: message.text,
                            type: message.type
                        };
                    }
                })
        }
    }


});

angular.module('messageFilters', []).filter('dateSpan', function() {
    return function(items, startDate, endDate) {
        var filtered = [];
        var start = null;
        var end = null;
        if (startDate != null) {
            var startParts = startDate.split("-");
            start = new Date(startParts[2], startParts[1] - 1, startParts[0]);
            start.setHours(0, 0, 0); // Show from the start of the day

        }
        if (endDate != null) {
            var endParts = endDate.split("-");
            end = new Date(endParts[2], endParts[1] - 1, endParts[0]);
            end.setHours(23, 59, 59); // Show until the end of the day
        }
        angular.forEach(items, function(item) {
            var show = true;
            if ( start != null) {
                if (item.date < start.getTime()) {
                    show = false;
                }
            }
            if (end != null) {
                if (item.date > end.getTime()) {
                    show = false;
                }
            }
            if (show) {
                filtered.push(item);
            }
        });
        return filtered;
    };
});