<!DOCTYPE html>
<html>
<head>
    <link rel="icon" href="img/appart_logo.png">
    <script src="js/angular-1.6.0.js"></script>
    <link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/angular_material/1.1.0/angular-material.min.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link href="css/datepicker.css" rel="stylesheet" type="text/css"/>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <script src="js/datepicker.js"></script>
    <script src="js/messages.js"></script>
    <meta charset="UTF-8" name="viewport" content="width=device-width, initial-scale=1"/>
    <title>Cortex Customer Care</title>
</head>
<body>
<div ng-app="messageTable" ng-controller="messageControler">
    <div ng-show="error">
        <h2>{{ errorMessage }}</h2>
    </div>
    <div ng-show="containsData" class="panel panel-primary">
        <div class="panel-heading text-right">
            <span>
                Message Type: <input type="text" ng-model="inputMessageType" style="color:#000000"/>
            </span>
            <span>
                Text: <input type="text" ng-model="inputText" style="color:#000000"/>
            </span>
            <span>
                Start Date: <input type="text" id="inputStartDate" ng-change="changeVal()" ng-model="inputStartDate" placeholder="Start Date"></input>
            </span>
            <span>
                End Date: <input type="text" id="inputEndDate" ng-model="inputEndDate" placeholder="End Date" style="color:#000000"></input>
            </span>
        </div>
        <div class="panel-body">
            <table class="table table-striped table-hover">
                <tr class="row">
                    <th class="col-md-2">
                        <a href="" ng-click="sortFunction('date'); sortBy = 'date';">
                            <span ng-show="sortBy != 'date'" class="glyphicon glyphicon-sort"></span>
                            <span ng-show="sortBy == 'date' && !sortReverse" class="glyphicon glyphicon-arrow-up"></span>
                            <span ng-show="sortBy == 'date' && sortReverse" class="glyphicon glyphicon-arrow-down"></span>
                            SENT DATE
                        </a>
                    </th>
                    <th class="col-md-4">
                        <a href="" ng-click="sortFunction('text'); sortBy = 'text';">
                            <span ng-show="sortBy != 'text'" class="glyphicon glyphicon-sort"></span>
                            <span ng-show="sortBy == 'text' && !sortReverse" class="glyphicon glyphicon-arrow-up"></span>
                            <span ng-show="sortBy == 'text' && sortReverse" class="glyphicon glyphicon-arrow-down"></span>
                            TEXT
                        </a>
                    </th>
                    <th class="col-md-2">
                        <a href="" ng-click="sortFunction('campaignNodePart'); sortBy = 'campaignNodePart';">
                            <span ng-show="sortBy != 'campaignNodePart'" class="glyphicon glyphicon-sort"></span>
                            <span ng-show="sortBy == 'campaignNodePart' && !sortReverse" class="glyphicon glyphicon-arrow-up"></span>
                            <span ng-show="sortBy == 'campaignNodePart' && sortReverse" class="glyphicon glyphicon-arrow-down"></span>
                            CAMPAIGN PART
                        </a>
                    </th>
                    <th class="col-md-2">
                        <a href="" ng-click="sortFunction('type'); sortBy = 'type';">
                            <span ng-show="sortBy != 'type'" class="glyphicon glyphicon-sort"></span>
                            <span ng-show="sortBy == 'type' && !sortReverse" class="glyphicon glyphicon-arrow-up"></span>
                            <span ng-show="sortBy == 'type' && sortReverse" class="glyphicon glyphicon-arrow-down"></span>
                            MESSAGE TYPE
                        </a>
                    </th>
                    <th class="col-md-2"></th>
                </tr>
                <tr class="row" ng-repeat="message in messagesArray = (messages | filter:{text:inputText, type:inputMessageType} | dateSpan:inputStartDate:inputEndDate) | orderBy:sortBy:sortReverse | limitTo:pageSize:currentPage*pageSize track by $index"
                    ng-click="isSelected(message)">
                    <td class="col-md-2">{{ message.date | date: 'dd-MM-yyyy HH:mm:ss' }}</td>
                    <td class="col-md-4">{{ message.text }}</td>
                    <td class="col-md-2">{{ message.campaignNodePart }}</td>
                    <td class="col-md-2">{{ message.type }}</td>
                    <td class="col-md-2 text-center">
                        <button ng-click="resend(message)" class="btn-primary btn-lg glyphicon glyphicon-envelope" data-toggle="tooltip" data-placement="top" title="Resend SMS"/>
                    </td>
                </tr>
            </table>
        </div>
        <div class="container-fluid panel-primary" ng-if="selectedMessage != null">
            <div class="panel-heading">Selected Message</div>
            <div class="panel-body">
                <table class="table table-striped">
                    <tr class="row">
                        <th class ="col-md-2">Description:</th>
                        <td class="col-md-10">{{ selectedMessage.description }}</td>
                    </tr>
                    <tr class="row">
                        <th class="col-md-2">Start Date:</th>
                        <td class="col-md-10">{{ selectedMessage.dateStart | date: 'dd-MM-yyyy HH:mm:ss'}}</td>
                    </tr>
                    <tr class="row">
                        <th class="col-md-2">End Date:</th>
                        <td class="col-md-10">{{ selectedMessage.dateEnd | date: 'dd-MM-yyyy HH:mm:ss'}}</td>
                    </tr>
                    <tr class="row" ng-if='selectedMessage.duration != " "'>
                        <th class="col-md-2">Duration:</th>
                        <td class="col-md-10">{{ selectedMessage.duration }}</td>
                    </tr>
                    <tr class="row">
                        <th class="col-md-2">Text:</th>
                        <td class="col-md-10">{{ selectedMessage.text }}</td>
                    </tr>
                    <tr class="row">
                        <th class="col-md-2">Sent Date:</th>
                        <td class="col-md-10">{{ selectedMessage.date | date: 'dd-MM-yyyy HH:mm:ss' }}</td>
                    </tr>
                    <tr class="row">
                        <th class="col-md-2">Message Type:</th>
                        <td class="col-md-10">{{ selectedMessage.type }}</td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="text-center">
            <ul class="pagination" ng-if="totalPages > 1">
                <li ng-class="{disabled:currentPage == 0}">
                    <a href = "" ng-click="setPage(0)">First</a>
                </li>
                <li ng-class="{disabled:currentPage == 0}">
                    <a href = "" ng-click="setPage(currentPage - 1)">Previous</a>
                </li>
                <li ng-repeat="page in pageRange(messagesArray.length)" ng-class="{active:currentPage == page}">
                    <a href = "" ng-click="setPage(page)">{{ page + 1 }}</a>
                </li>
                <li ng-class="{disabled:currentPage == totalPages - 1}">
                    <a href = "" ng-click="setPage(currentPage + 1)">Next</a>
                </li>
                <li ng-class="{disabled:currentPage == totalPages - 1}">
                    <a href = "" ng-click="setPage(totalPages - 1)">Last</a>
                </li>
            </ul>
        </div>
    </div>
</div>
</body>
</html>
