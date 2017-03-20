$( function() {
    $( "#inputStartDate" ).datepicker({
        showOtherMonths: true,
        dateFormat: 'dd-mm-yy',
        onSelect: function(dateText, inst) {
            $scope.inputStartDate = $("#inputStartDate").val();
        }
    })
} );

$( function() {
    $( "#inputEndDate" ).datepicker({
        showOtherMonths: true,
        dateFormat: 'dd-mm-yy',
        onSelect: function(dateText, inst) {
            $scope.inputEndDate = $("#inputEndDate").val();
        }
    })
} );

Date.prototype.restFormat = function() {
    var mm = this.getMonth() + 1; // getMonth() is zero-based
    var dd = this.getDate();
    var HH = this.getHours();
    var MM = this.getMinutes();
    var ss = this.getSeconds();

    return [
        [(dd>9 ? '' : '0') + dd,
            (mm>9 ? '' : '0') + mm,
            this.getFullYear()
        ].join('/'),
        [(HH>9 ? '' : '0') + HH,
            (MM>9 ? '' : '0') + MM,
            (ss>9 ? '' : '0') + ss
        ].join(':')
    ].join(' ');
};