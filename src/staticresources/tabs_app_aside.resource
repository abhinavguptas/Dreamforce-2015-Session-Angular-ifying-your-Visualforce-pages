PK
     �|G               js/PK
     �f-Go1�+�  �  	   js/app.jsangular.module('starter', ['ionic', 'starter.controllers', 'starter.services'])

.run(function($ionicPlatform) {
  $ionicPlatform.ready(function() {
    // Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
    // for form inputs)
    if (window.cordova && window.cordova.plugins && window.cordova.plugins.Keyboard) {
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
      cordova.plugins.Keyboard.disableScroll(true);

    }
    if (window.StatusBar) {
      // org.apache.cordova.statusbar required // some other change
      StatusBar.styleLightContent(); 
    }
  });
})

.config(function($stateProvider, $urlRouterProvider) {

  // Ionic uses AngularUI Router which uses the concept of states
  // Learn more here: https://github.com/angular-ui/ui-router
  // Set up the various states which the app can be in.
  // Each state's controller can be found in controllers.js
  $stateProvider

  // setup an abstract state for the tabs directive
    .state('tab', {
    url: '/tab',
    abstract: true,
    templateUrl: VFPageData.resources.mavens_app_base + 'templates/tabs.html'
  })

  // Each tab has its own nav history stack:

  .state('tab.dash', {
    url: '/dash',
    views: {
      'tab-dash': {
        templateUrl: VFPageData.resources.mavens_app_base + 'templates/tab-dash.html',
        controller: 'DashCtrl'
      }
    }
  })

  .state('tab.tasks', {
      url: '/tasks',
      views: {
        'tab-tasks': {
          templateUrl: VFPageData.resources.mavens_app_base + 'templates/tab-tasks.html',
          controller: 'TasksCtrl'
        }
      }
    })
    
  .state('tab.events', {
    url: '/events/:when',
    views: {
      'tab-events': {
        templateUrl: VFPageData.resources.mavens_app_base + 'templates/tab-events.html',
        controller: 'EventsCtrl'
      }
    }
  });

  // if none of the above states are matched, use this as the fallback
  $urlRouterProvider.otherwise('/tab/dash');

});
PK
     �|G               css/PK
     ,lGE�l�         css/style.css PK
     fkG|w�U�  �     js/controller.jsangular.module('starter.controllers', ['starter.services'])

.controller('DashCtrl', function($scope, RemoteTK) {
    $scope.taskCount = '...';
    $scope.eventcount = '...';
    $scope.eventTomorrowCount = '...';

    RemoteTK.query('Select count(Id) taskcount from Task where ActivityDate >= TODAY and IsClosed = false')
        .then(function(records) {
            $scope.taskCount = records && records.length && records[0].taskcount;
        })
    RemoteTK.query('Select count(Id) eventcount from Event where ActivityDate = TODAY')
        .then(function(records) {
            $scope.eventCount = records && records.length && records[0].eventcount;
        })
    RemoteTK.query('Select count(Id) eventcount from Event where ActivityDate = TOMORROW')
        .then(function(records) {
            $scope.eventTomorrowCount = records && records.length && records[0].eventcount;
        })

})


.controller('TasksCtrl', function($scope, RemoteTK) {
    $scope.showBulkComplete = false;

    $scope.toggleComplete = function() {
        $scope.showBulkComplete = !$scope.showBulkComplete;
    }

    $scope.edit = function(task) {
        location.href = '/' + task.Id + '/e';
    };

    $scope.complete = function(task) {
        $scope.tasks.splice($scope.tasks.indexOf(task), 1);
        RemoteTK.update('Task', task.Id, {
            'Status': 'Completed'
        });
    };

    RemoteTK.query('Select Id, Subject, ActivityDate from Task where ActivityDate = TODAY and IsClosed = false Order By ActivityDate LIMIT 20')
        .then(function(records) {
            $scope.tasks = records;
        })

})


.controller('EventsCtrl', function($scope, $stateParams, RemoteTK) {
    var activityDateFilter = $stateParams.when == 'today' ? 'TODAY' : 'TOMORROW';
    console.log($stateParams.when);
    $scope.edit = function(evt) {    
        location.href = '/' + evt.Id + '/e';        
    };
    $scope.view = function(evt) {    
        location.href = '/' + evt.Id;        
    };
    RemoteTK.query('Select Id, Subject, ActivityDateTime from Event where ActivityDate >= ' + activityDateFilter + ' Order By ActivityDateTime LIMIT 20')
        .then(function(records) {
            $scope.events = records;
        })

});
PK
     mkG�dFI         js/services.jsangular.module('starter.services', [])

/**
 * A simple example service that returns some data.
 */
.service('RemoteTK', function($q) {
  //get remotetk client
  var _remoteTKClient = new remotetk.Client();   
  this.query = function(queryString) {
    var deferred = $q.defer();
    //Call RemoteTK's query API  
    _remoteTKClient.query(queryString, 
      function(response) {        
        deferred.resolve(response.records);//return result as promised earlier
      },
      function(error) {
        alert(JSON.stringify(error));
        deferred.reject(error);//send error as promised earlier
      });
    //promise that we will return something (asynchoronusly in the future)
    return deferred.promise;
  };

  this.update = function(objtype, id, fields) {
    var deferred = $q.defer();
    //Call RemoteTK's query API  
    _remoteTKClient.update(objtype, id, fields, 
      function(response) {        
        console.log(response);
        deferred.resolve('done');//return result as promised earlier
      },
      function(error) {
        alert(JSON.stringify(error));
        deferred.reject(error);//send error as promised earlier
      });
    //promise that we will return something (asynchoronusly in the future)
    return deferred.promise;
  };

})


PK
     �|G            
   templates/PK
     i-G6�O�  �     templates/tabs.html<!--
Create tabs with an icon and label, using the tabs-positive style.
Each tab's child <ion-nav-view> directive will have its own
navigation history that also transitions its views in and out.
-->
<ion-tabs class="tabs-icon-top tabs-color-active-positive">

  <!-- Dashboard Tab -->
  <ion-tab title="Dashboard" 
    icon-off="ion-ios-body-outline" icon-on="ion-ios-body" 
      href="#/tab/dash">
    <ion-nav-view name="tab-dash"></ion-nav-view>
  </ion-tab>
   
   <!-- tasks -->
  <ion-tab title="Tasks" 
    icon-off="ion-ios-checkmark-outline" icon-on="ion-ios-checkmark" 
      href="#/tab/tasks">
    <ion-nav-view name="tab-tasks"></ion-nav-view>
  </ion-tab>

  <!-- Events Tab -->
  <ion-tab title="Events" icon-off="ion-ios-calendar-outline" 
    icon-on="ion-ios-calendar" href="#/tab/events/today">
    <ion-nav-view name="tab-events"></ion-nav-view>
  </ion-tab>
  


</ion-tabs>
PK
     �h/G�ϧ��  �     templates/tab-dash.html<ion-view view-title="Today" cache-view="false">
    <ion-content class="padding">
        <div class="list card">
            <!-- Comment -->
            <div class="item item-divider">Tasks</div>
            <div class="item item-icon-right" ui-sref="tab.tasks">
                You have <b>{{taskCount}}</b> tasks to complete
                <i class="icon ion-ios-arrow-right"></i>
            </div>
        </div>
        <div class="list card">
            <div class="item item-divider">Events</div>
            <div class="item item-icon-right" ui-sref="tab.events({'when' : 'today'})">
                You've
                <b>{{eventCount}}</b> meetings today.
                <i class="icon ion-ios-arrow-right"></i>
            </div>
        </div>
        <div class="list card">
            <div class="item item-divider">Upcoming</div>
            <div class="item item-icon-right" ui-sref="tab.events({'when' : 'tomorrow'})">
                You've
                <b>{{eventTomorrowCount}}</b> meetings tomorrow.
                <i class="icon ion-ios-arrow-right"></i>
            </div>
        </div>
    </ion-content>
</ion-view>
PK
     xf-G�p}D�  �     templates/tab-tasks.html<ion-view view-title="Tasks">
    <ion-nav-buttons side="primary">
        <button class="button button-icon icon ion-ios-checkmark-outline" ng-click="toggleComplete()">          
        </button>
    </ion-nav-buttons>

    <ion-content>        
        <!-- The list directive is great, but be sure to also checkout the collection repeat directive when scrolling through large lists -->
        <ion-list can-swipe="true" show-delete="showBulkComplete">
            <ion-item ng-repeat="task in tasks" item="task" class="item-remove-animate" href="/{{task.Id}}">
                {{ task.Subject }}
                <p>
                  {{task.ActivityDate | date:'longDate'}}
                </p>
                <ion-delete-button class="button-positive ion-ios-checkmark " ng-click="complete(task)">
                </ion-delete-button>
                <ion-option-button class="button button-positive" ng-click="edit(task)">
                    <i class="ion-edit"></i>
                </ion-option-button>
                <ion-option-button class="button button-balanced" ng-click="complete(task)">
                    <i class="ion-ios-checkmark"></i>
                </ion-option-button>
            </ion-item>
        </ion-list>
    </ion-content>
</ion-view>
PK
     �f-G�U{��  �     templates/tab-events.html<ion-view view-title="Events">
    <ion-content> 
        <ion-list can-swipe="true">
            <ion-item ng-repeat="event in events" item="event" class="item-remove-animate item-icon-right">
                <div class="row" ng-click="view(event)">
                    <div class="col col-20 dark" style="font-size: small;">
                        {{event.ActivityDateTime | date:'dd MMM'}}
                        <p style="font-size: small;">
                            {{event.ActivityDateTime | date:'shortTime'}}
                        </p>
                    </div>
                    <div class="col">
                        <h2>{{ event.Subject }}</h2 >
                    </div>                    
                </div>                  
                <span class="icon" ng-click="edit(event)">     
                  <i class="ion-ios-compose-outline" ></i>
                </span>
            </ion-item>
        </ion-list>
    </ion-content>
</ion-view>
PK 
     �|G                            js/PK 
     �f-Go1�+�  �  	             !   js/app.jsPK 
     �|G                          css/PK 
     ,lGE�l�                   -  css/style.cssPK 
     fkG|w�U�  �               Y  js/controller.jsPK 
     mkG�dFI                   A  js/services.jsPK 
     �|G            
            m  templates/PK 
     i-G6�O�  �               �  templates/tabs.htmlPK 
     �h/G�ϧ��  �               G  templates/tab-dash.htmlPK 
     xf-G�p}D�  �                  templates/tab-tasks.htmlPK 
     �f-G�U{��  �               .$  templates/tab-events.htmlPK      �  9(    