import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myshop/helpers/custom_route.dart';
import 'package:myshop/screen/splash_screen.dart';
// this import for using provider package
import 'package:provider/provider.dart';

import './screen/product_detail_screen.dart';
import './screen/products_overview_screen.dart';
import './screen/cart_screen.dart';
import './screen/order_screen.dart';
import './screen/user_product_screen.dart';
import './screen/edit_product_screen.dart';
import './screen/auth_screen.dart';
import './provider/product_provider.dart';
import './provider/cart_provider.dart';
import './provider/order_provider.dart';
import './provider/auth_provider.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light
    )
  );
  runApp(MyApp());
} 

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return ChangeNotifierProvider if want to use provider
    /// ChangeNotifierProvider is a class that allows
    /// us to register a class to which you can listen in child widget
    /// and whatever that class updates, the widget which are listening
    /// and only those, not all child widget
    /// Only child widget which are listening will rebuild
    /// yang butuh provider itu ProductsOverviewScreen
    // return ChangeNotifierProvider(
    //   /// we have to provide builder method
    //   builder: (ctx) => ProductProvider(), // all child widget will also listen to this provider
    //   child: MaterialApp(
    //     title: 'MyShop',
        
    //     theme: ThemeData(
    //       primarySwatch: Colors.green,
    //       accentColor: Colors.greenAccent,
    //       fontFamily: 'Lato',
    //     ),
        
    //     // home: ProductsOverviewScreen(),
    //     initialRoute: '/',
    //     routes: {
    //       '/' : (ctx) => ProductsOverviewScreen(),
    //       ProductDetailScreen.routeName : (ctx) => ProductDetailScreen(),
    //     },
    //   ),
    // );

    /// alternatif lain dari syntax ChangeNotifierProvider (fungsinya sama aja kayak di atas)
    /// keuntungannya, nggak bergantung pada context
    return MultiProvider(
      // hold multiple provider
      providers: [
        ChangeNotifierProvider.value(
          value: AuthProvider(),
        ),
        /// use ChangeNotifierProxyProvider for 
        /// First arugment for which provider
        /// Second argument for which type of data you will provide
        ChangeNotifierProxyProvider<AuthProvider, ProductProvider>(
          /// we have to provide builder method
          builder: (ctx, auth, previousProducts) 
                      => ProductProvider(
                        auth.token,
                        auth.userId, 
                        previousProducts == null ? [] : previousProducts.items
                      ),
        ),
        ChangeNotifierProvider.value(
          /// we have to provide builder method
          value: CartProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrderProvider>(
          builder: (ctx, auth, order) => OrderProvider(
            auth.token,
            auth.userId, 
            order == null ? [] : order.orderList
          ),
        )
      ],
      /// make that we will rebuilt on MaterialApp only by adding
      /// Consumer.of()
      // all child widget will also listen to this provider
      child: Consumer<AuthProvider>(
        // change '_' with 'child' if we have static part to rebuild (?)
        /// this ensures that MaterialApp is rebuilt whenever auth changes,
        /// whenever that auth object changes this builder runs again and
        /// gives us a new MaterialApp
        builder: (ctx, auth, _) => MaterialApp(
          title: 'MyShop',
          
          debugShowCheckedModeBanner: false, // remove debug banner

          theme: ThemeData(
            primarySwatch: Colors.green,
            accentColor: Colors.greenAccent,
            fontFamily: 'Lato',
            // implement CustomRoute on all route
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                // define transition between iOS and Android
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              }
            )
          ),
          
          home: auth.isAuth ? ProductsOverviewScreen() : FutureBuilder(
            future: auth.autoSignIn(),
            builder: (ctx, authResultSnapshot) => 
                       authResultSnapshot.connectionState == ConnectionState.waiting ? 
                          SplashScreen() 
                          : AuthScreen(),
          ) ,
          // initialRoute: '/',
          routes: {
            // '/' : (ctx) => AuthScreen(),
            ProductDetailScreen.routeName : (ctx) => ProductDetailScreen(),
            CartScreen.routeName : (ctx) => CartScreen(),
            OrderScreen.routeName : (ctx) => OrderScreen(),
            UserProductScreen.routeName : (ctx) => UserProductScreen(),
            EditProductScreen.routeName : (ctx) => EditProductScreen(),
            // ProductsOverviewScreen.routeName : (ctx) => ProductsOverviewScreen()
          },
        ),
      ) 
    );
  }
}
