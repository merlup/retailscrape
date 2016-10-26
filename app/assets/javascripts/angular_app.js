var app = angular.module("RetailScrape", ['ngAnimate',  'ui.router', 'rails' ]);
app.factory('Product', ['railsResourceFactory',function(railsResourceFactory){
 return railsResourceFactory({url: '/products', name: 'product'});
}]);

app.config(function($stateProvider, $urlRouterProvider, $locationProvider) {
    $stateProvider.state('/products', { url: 'products',  views: {'products': { templateUrl: 'products', controller: 'ProductsCtrl'}}})
    .state('home', { url: '/',  views: {'main': { templateUrl: 'home', controller: 'MainCtrl'}}})
    .state('products', { url: 'products',  views: {'main': { templateUrl: 'products', controller: 'MainCtrl'}}})
    .state('collections', { url: 'collections',  views: {'main': { templateUrl: 'collections', controller: 'MainCtrl'}}})
    .state('log_in', { url: 'log_in',  views: {'main': { templateUrl: 'sessions/new', controller: 'MainCtrl'}}})
   .state('log_out', { url: '',  views: {'main': { templateUrl: 'logout', controller: 'MainCtrl'}}})
   .state('sign_up', { url: 'collections',  views: {'main': { templateUrl: 'users/new', controller: 'MainCtrl'}}})
   .state('delete_all', { url: 'products',  views: {'main': { templateUrl: 'destroy_all', controller: 'MainCtrl'}}})
$locationProvider.html5Mode({ enabled: true, requireBase: false });

});

app.controller("MainCtrl",['$scope' , function($scope) {

}]);


app.controller("ProductsCtrl", ['$scope', "Product",  function($scope, Product) {
    
    var total_products = 0;
    var back_button = document.getElementById("back");
    var next_button = document.getElementById("next");
    var page_index = document.getElementById("pages");
    Product.query({ id: 'id' }).then(function (results) {
        $scope.user_products = results;  
        $scope.current_count = $scope.user_products.length 
        total_products = $scope.user_products.length
        if (results.length < 30) {
            next_button.style.visibility = "hidden" ;
        }
    });
    
    var user_products = 0;

    
    $scope.get_updates = function() {
        
        var timer = setInterval(function() {
            Product.query().then(function (results) {
                $scope.user_products = results;
                $scope.current_count = results.length
                user_products = results.length;  
                if ($scope.current_count > total_products) {
                    if (results.length < 30) {
                        next_button.style.visibility = "hidden" ;
                    }
                    else {
                        next_button.style.visibility = "visible" ;
                    }
                }
            });
        },200)
        
    }

    var counter = 0; 

    $scope.nextPage = function(product_total) {
       counter += 1 ; 
        var page_max =  Math.round((product_total) / 30) - 1;
        $scope.products_per_page = Product.query({page: counter + 1}).then(function (results) {
            $scope.user_products = results;
            $scope.searching = false;
            if (counter >= page_max ) {
                next_button.style.visibility = "hidden" ;
            }
            if (counter == 0) {
                back_button.style.visibility = "hidden" ;
            }
        });
         $scope.counter = counter;
         $scope.page_max = page_max;
        back_button.style.visibility = "visible" ;
        page_index.style.visibility = "visible";
    } 
  
   

    $scope.backPage = function(product_total) {
        counter = counter - 1 ; 
        var page_max =  Math.round((product_total) / 30) - 1;
        if (counter > 0 ) {
            $scope.products_per_page = Product.query({page: counter}).then(function (results) {
                $scope.user_products = results;
                $scope.searching = false;
                    if (counter < page_max ) {
                        next_button.style.visibility = "visible" ;
                    }
            });
        } 

        if (counter <= 0) {
            $scope.products_per_page = Product.query({page: counter}).then(function (results) {
                $scope.user_products = results;
                $scope.searching = false;
            });
            back_button.style.visibility = "hidden" ;
        }
         $scope.counter = counter;
         $scope.page_max = page_max;
        page_index.style.visibility = "visible";
           
    }
}]);
