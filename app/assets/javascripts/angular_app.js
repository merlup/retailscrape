var app = angular.module("RetailScrape", ['ngAnimate', 'angularUtils.directives.dirPagination', 'ui.router', 'rails', 'ngFileUpload' ]);

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
$scope.line_items = [];
$scope.collections = [];
    $scope.delete_api_key = function (api_key) {
        ApiKey.$delete("api_keys/" + api_key.id);
        $scope.api_keys.splice($scope.api_keys.indexOf(api_key), 1);
        setTimeout(function() {
            ApiKey.query().then(function (results) {
                $scope.api_keys = results;
            });
        },500)
     
    };


    $scope.delete_line_item = function (line_item) {
       LineItem.$delete("line_items/" + line_item.id);
        setTimeout(function() {
        $scope.line_items.splice($scope.line_items.indexOf(line_item), 1);
            Collection.query().then(function (results) {
            $scope.collections = results;  
        });
        },500)

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


app.controller("ProductsCtrl", ['$scope', "Product", "Collection", "LineItem", "Upload", "$http", function($scope, Product, Collection, LineItem, Upload, $http) {
    $scope.collections = [];
    var total_products = 0;
    var back_button = document.getElementById("back");
    var next_button = document.getElementById("next");
    var page_index = document.getElementById("pages");
    Product.query().then(function (results) {
        $scope.user_products = results;  
        $scope.current_count = $scope.user_products.length 
        total_products = $scope.user_products.length
    });

 

    $scope.scrape_products = function() {
        $http({
        method: 'POST',
        url: "get_products"});
    }

    var get_type = ""

    $scope.selectedType = function (value) {  
        get_type = value
        console.log(get_type)
    };

  

    var user_products = 0;

    $scope.add_to_collection = function(product, user_id) {
      
        $scope.upload = Upload.upload({
            url: '/add_to_collection', 
            fields: {'product_id' : product.id},
             sendFieldsAs: 'json'
            })
        ; 
        Collection.query().then(function (results) {
            $scope.collections = results;  
        });
    }

    $scope.delete_products = function() {
        $http({method: 'GET',url: '/destroy_all'
        }).success(function(){
            Product.query().then(function(results){
                $scope.user_products = results;
            });
        });
    }
   

        $scope.get_products_men = function() {
            $http({
                method: 'GET',
                url: "get_products_mens",
                params: {type: this.type}  
            }).success(function(){
            $scope.get_updates();  
            }).error(function(response){
                console.log(response);
               
            })
        }

         $scope.get_products_women = function() {
            $http({
                method: 'GET',
                url: "get_products_womens",
                params: {type: this.type}  
            }).success(function(){
                $scope.get_updates();
            }).error(function(response){
                console.log(response);
            })
        }

    var ping_products;
   $scope.get_updates = function() {
    var get_counter;
    $scope.counter = 0
    $scope.last = 0
    $scope.time = (Date.now()).toLocaleString();
    var ping_stopper;
        var get_products = function() {
            Product.query().then(function(results){
                $scope.user_products = results
                $scope.counter = results.length
            });
        }
        ping_products = setInterval(get_products,1000);
        get_counter = setInterval(function(){
            console.log("COUNTER: ",$scope.counter)
            $scope.$watch($scope.counter, function() {
                if($scope.counter > $scope.last) {
                        $scope.last = $scope.counter
                        $scope.time = (Date.now()).toLocaleString();
                    console.log("Counter Changed", $scope.counter, "Changed", "Counter Last",$scope.last)
                } else {
                    $scope.last = $scope.last
                    console.log("nothing updated", $scope.counter, "still the same")
                }
            })
        },1000)
       
       

      ping_stopper = setInterval(function() {
            $scope.current_check = (Date.now()).toLocaleString();
            console.log("checking to see if there were any updates", $scope.time, "Count Has increased since last check at ", $scope.last_check)
            if($scope.counter == $scope.last) {
                console.log("Stop Ping")
                clearInterval(ping_products );
                clearInterval(get_counter );
                clearInterval(ping_stopper );
            }
            $scope.last_check = $scope.current_check
        },20000)
     
    }
          
      
}]);
