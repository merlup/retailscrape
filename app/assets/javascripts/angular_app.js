var app = angular.module("RetailScrape", ['ngAnimate', 'rails-template-cache', 'angularUtils.directives.dirPagination', 'tjsModelViewer', 'ui.router', 'rails', 'ngFileUpload' ]);

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


var api_key_menu =  document.getElementById("api_key_menu");

$scope.unhide_menu = function() {
   var toggle = document.getElementById('api_key_menu');
   if (toggle.style.visibility == "hidden") {
    toggle.style.visibility = "visible"
   } else {
    toggle.style.visibility = "hidden"
   }
}



}]);



    app.controller('ApiKey',['$scope', 'ApiKey', 'Upload', function($scope, ApiKey, Upload){

    $scope.delete_api_key = function (api_key) {
        ApiKey.$delete("api_keys/" + api_key.id);
        $scope.api_keys.splice($scope.api_keys.indexOf(api_key), 1);
      
              ApiKey.query().then(function (results) {
                $scope.api_keys = results;
            });
       
     
     
    };

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

$scope.api_keys = [];


        ApiKey.query().then(function (results) {
            $scope.api_keys = results;
        });

    }]);

    
    app.controller('LineItem',['$scope', 'LineItem', function($scope, LineItem){
        LineItem.query().then(function (results) {
            $scope.line_items = results;  
        });
    }]);

    app.controller('Collection',  ['$scope', 'Collection', 'LineItem', function($scope, Collection, LineItem){


        $scope.line_items = [];
        $scope.collections = [];
           LineItem.query().then(function (results) {
            $scope.line_items = results;  
        });

         Collection.query().then(function (results) {
            $scope.collections = results;  
        });

    $scope.delete_line_item = function (line_item) {
       LineItem.$delete("line_items/" + line_item.id);
        setTimeout(function() {
        $scope.line_items.splice($scope.line_items.indexOf(line_item), 1);
            Collection.query().then(function (results) {
            $scope.collections = results;  
        });
        },500)

    };

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
   
var search_button =  document.getElementById("get_products_button");

$scope.unhide_menu = function(element) {
   var toggle = element;
   if (toggle.style.visibility == "hidden") {
    toggle.style.visibility = "visible"
   } else {
    toggle.style.visibility = "hidden"
   }
}  
 $scope.hideStuff = function () {
        $scope.startFade = true;
        setTimeout(function(){
            $scope.hidden = true;
        }, 2000);
        
    };

        $scope.get_products = function() {
            $scope.unhide_menu(search_button);
            document.getElementById('dancer').style.visibility = "visible"
            $scope.get_updates(); 
            $http({
                method: 'GET',
                url: "get_products",
                params: {type: this.type, store: this.store}  
            }).success(function(){
               setTimeout(function(){
                clearInterval(ping_products );
                $scope.hideStuff();
               console.log("Stoppping")
                  $scope.unhide_menu(search_button);
            },2000)
              
            }).error(function(response){
                setTimeout(function(){
                clearInterval(ping_products );
                document.getElementById('dancer').style.visibility = "hidden"
                 console.log("Stoppping")
                  $scope.unhide_menu(search_button);
            },2000)
            })
        }

    var ping_products;
   $scope.get_updates = function() {
        var get_products = function() {
            Product.query().then(function(results){
                $scope.user_products = results
                $scope.counter = results.length
            });
        }
        ping_products = setInterval(get_products,1000);
    }
          
      
}]);
