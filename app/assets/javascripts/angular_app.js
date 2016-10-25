var app = angular.module("RetailScrape", ['ui.router',  'rails' ]);

app.factory('Product', ['railsResourceFactory',function(railsResourceFactory){
 return railsResourceFactory({url: '/products', name: 'product'});
}]);

app.config(function($stateProvider, $urlRouterProvider, $locationProvider) {
    $stateProvider.state('/products', { url: 'products',  views: {'main': { templateUrl: 'products', controller: 'ProductsCtrl'}}})
    $locationProvider.html5Mode({ enabled: true, requireBase: false });
});

app.controller("ProductsCtrl", ['$scope', '$compile', '$timeout', "Product", '$location', '$http',  function($scope, $compile, $timeout,  Product, $http,  $location) {
    
    
    var total_products = 0;

    Product.query({ id: 'id' }).then(function (results) {
        $scope.user_products = results;  
        total_products = $scope.user_products.length
        console.log("Total PRODUCTS:",total_products);
    });

    var user_products = [];
       if( user_products.length > 0) {
        clearInterval(timer);
        }

  
        $scope.start_get = function() {
            var timer = setInterval(function() {
                check_updates();
                console.log("Calling");
            },500);
        }

    

    function check_updates() {
        var current_count = 0;
        Product.query().then(function (results) {
         current_count = results.length;  
        console.log("Current Count:", current_count);

         if (current_count > total_products) {
                Product.query().then(function (results) {
                   $scope.user_products = results;
                   user_products = $scope.user_products;
                   console.log("User Product count", results.length);
                });
            if (current_count == 90) {
                
                console.log("reset");
                clearInterval(timer);;
            }
        }
        
        });
    
       
    }
 
    // $scope.$watch( $scope.products, function() {
    //     setInterval(function() {
    //         Product.query().then(function (results) {
    //             $scope.user_products = results;
    //         });
    //     }); 
    // });

}]);
