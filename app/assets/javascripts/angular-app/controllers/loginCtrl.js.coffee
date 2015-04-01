
angular.module('app.loginApp').controller("LoginCtrl", [
  '$scope',
  ($scope)->

    $scope.notice = "Enter a password"
    $scope.confirm = "Confirm the password"
    $scope.title = "Messaging"

])
