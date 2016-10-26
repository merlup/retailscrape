var app = angular.module("RetailScrape", ['ngAnimate',  'ui.router', 'rails', 'ngFileUpload' ]);

app.factory('Product', ['railsResourceFactory',function(railsResourceFactory){
 return railsResourceFactory({url: '/products', name: 'product'});
}]);

app.factory('LineItem', ['railsResourceFactory',function(railsResourceFactory){
 return railsResourceFactory({url: '/line_items', name: 'line_item'});
}]);

app.factory('Collection', ['railsResourceFactory',function(railsResourceFactory){
 return railsResourceFactory({url: '/collections', name: 'collection'});
}]);

app.factory('ApiKey', ['railsResourceFactory',function(railsResourceFactory){
 return railsResourceFactory({url: '/api_keys', name: 'api_key'});
}]);

app.config(function($stateProvider, $urlRouterProvider, $locationProvider) {
    $stateProvider.state('/products', { url: 'products',  views: {'products': { templateUrl: 'products', controller: 'ProductsCtrl'}}})
    .state('home', { url: '/',  views: {'main': { templateUrl: 'home', controller: 'MainCtrl'}}})
    .state('products', { url: 'products',  views: {'main': { templateUrl: 'products', controller: 'MainCtrl'}}})
    .state('collections', { url: 'collections',  views: {'main': { templateUrl: 'collections', controller: 'MainCtrl'}}})
    .state('log_in', { url: 'log_in',  views: {'main': { templateUrl: 'sessions/new', controller: 'MainCtrl'}}})
   .state('log_out', { url: '',  views: {'main': { templateUrl: 'logout', controller: 'MainCtrl'}}})
   .state('sign_up', { url: 'sign_up',  views: {'main': { templateUrl: 'users/new', controller: 'MainCtrl'}}})
   .state('delete_all', { url: 'products',  views: {'main': { templateUrl: 'destroy_all', controller: 'MainCtrl'}}})
$locationProvider.html5Mode({ enabled: true, requireBase: false });

});

app.controller("MainCtrl" ,['$scope', "ApiKey" , 'Collection', 'LineItem', 'Upload',  '$http', function($scope, ApiKey, Collection, LineItem, Upload, $http) {

$scope.api_keys = [];

    $scope.delete_api_key = function (api_key) {
        ApiKey.$delete("api_keys/" + api_key.id);
        $scope.api_keys.splice($scope.api_keys.indexOf(api_key), 1);
        setTimeout(function() {
            ApiKey.query().then(function (results) {
                $scope.api_keys = results;
            });
        },1000)
     
    };

    $scope.delete_line_item = function (line_item) {
       LineItem.$delete("line_items/" + line_item.id);
        setTimeout(function() {
        $scope.line_items.splice($scope.line_items.indexOf(line_item), 1);
            Collection.query().then(function (results) {
            $scope.collections = results;  
        });
        },1000)

    };


    ApiKey.query().then(function (results) {
        $scope.api_keys = results;
       
    });


    $scope.create_api_key = function(user_id) {

        $scope.upload = Upload.upload({
                  url: '/api_keys', 
                  fields: {
                    'api_key[access_token]' : null,
                    'api_key[user_id]' : user_id,
                  },
                 sendFieldsAs: 'json'
              }).progress(function(evt) {
               }).success(function(data, status, headers, config) {
                 
              });
              setTimeout(function(){

                  ApiKey.query().then(function (results) {
            $scope.api_keys = results;
        
        });
              },100) 
      
    }

    LineItem.query().then(function (results) {
        $scope.line_items = results;  
    });




     Collection.query().then(function (results) {
        $scope.collections = results;  
    });




}]);


app.controller("ProductsCtrl", ['$scope', "Product", "Collection", "LineItem", "Upload", function($scope, Product, Collection, LineItem, Upload) {
    
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
        $scope.scrape_products = function() {
        $http({
        method: 'POST',
        url: "get_products"});
    }

    var user_products = 0;

    $scope.add_to_collection = function(product, user_id) {
     
      
        $scope.upload = Upload.upload({
                  url: '/add_to_collection', 
                  fields: {
                    'product_id' : product.id
                },
                 sendFieldsAs: 'json'
              }).progress(function(evt) {
             }).success(function(data, status, headers, config) {
             
              }); 
    }

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
