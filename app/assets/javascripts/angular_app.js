var app = angular.module("RetailScrape", ['ui.router',  'rails' ]);
app.factory('Product', ['railsResourceFactory',function(railsResourceFactory){
 return railsResourceFactory({url: '/products', name: 'product'});
}]);

app.config(function($stateProvider, $urlRouterProvider, $locationProvider) {
    $stateProvider.state('/products', { url: 'products',  views: {'products': { templateUrl: 'products', controller: 'ProductsCtrl'}}})
    .state('home', { url: '/',  views: {'main': { templateUrl: '', controller: 'MainCtrl'}}})
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
    Product.query({ id: 'id' }).then(function (results) {
        $scope.user_products = results;  
        total_products = $scope.user_products.length
    });

    var user_products = [];
    $scope.start_get = function() {
        var timer = setInterval(function() {
            check_updates();
        });
    }

    if( user_products.length > 90) {
        clearInterval(timer);
    }

    function check_updates() {
        var current_count = 0;
        Product.query().then(function (results) {
            current_count = results.length;  
            if (current_count > total_products) {
                Product.query().then(function (results) {
                   $scope.user_products = results;
                   user_products = $scope.user_products;
                    if (results.length < 30) {
                        console.log(results.length);
                        next_button.style.visibility = "hidden" ;
                    }
                    else {
                        next_button.style.visibility = "visible" ;
                    }
                });
            }
        });  
    }

    Product.query().then(function (results) {
        if (results.length < 30) {
        next_button.style.visibility = "hidden" ;
        }
    })

    var counter = 0; 
    var back_button = document.getElementById("back");
    var next_button = document.getElementById("next");
    
   

    $scope.nextPage = function(product_total) {
       counter += 1 ; 
        var page_max =  Math.round((product_total) / 30) - 1;
       console.log(counter,page_max)
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
       
        back_button.style.visibility = "visible" ;
       
    
    }   

    $scope.backPage = function(product_total) {
        counter = counter - 1 ; 
        var page_max =  Math.round((product_total) / 30) - 1;
          console.log(counter,page_max)
        if (counter > 0 ) {
            $scope.products_per_page = Product.query({page: counter}).then(function (results) {
                $scope.user_products = results;
                $scope.searching = false;
                    if (counter < page_max ) {
                        next_button.style.visibility = "visible" ;
                    }
            });
        } 
        
           
    }
}]);
