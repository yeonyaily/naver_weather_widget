package es.antonborri.home_widget_example

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider


class HomeWidgetExampleProvider : HomeWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.example_layout).apply {
                // Open App on Widget Click
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                        context,
                        MainActivity::class.java)
                setOnClickPendingIntent(R.id.widget_container, pendingIntent)

                // Swap Title Text by calling Dart Code in the Background
                /*
                setTextViewText(R.id.widget_title, widgetData.getString("title", null)
                        ?: "No Title Set")
                val backgroundIntent = HomeWidgetBackgroundIntent.getBroadcast(
                        context,
                        Uri.parse("homeWidgetExample://titleClicked")
                )
                setOnClickPendingIntent(R.id.widget_title, backgroundIntent)

                val message = widgetData.getString("message", null)
                setTextViewText(R.id.widget_message, message
                        ?: "No Message Set")
                // Detect App opened via Click inside Flutter
                val pendingIntentWithData = HomeWidgetLaunchIntent.getActivity(
                        context,
                        MainActivity::class.java,
                        Uri.parse("homeWidgetExample://message?message=$message"))
                setOnClickPendingIntent(R.id.widget_message, pendingIntentWithData)

                 */
                val temperature = "기온 : " + widgetData.getString("temperature", null)
                setTextViewText(R.id.widget_temperature, temperature?: "No Temperature Set")

                val description = widgetData.getString("description", null)
                setTextViewText(R.id.widget_description, description?: "No Description Set")

                val rainFall = "강수량 : " + widgetData.getString("rainFall", null)
                setTextViewText(R.id.widget_rainFall, rainFall?: "No rainFall Set")

                val location = widgetData.getString("location", null)
                setTextViewText(R.id.widget_location, location?: "No location Set")

                // 코틀린에서 when문은 다른 언어의 switch문과 동일하다.
                println(description.toString());
                println(temperature.toString());
                val weather_img = when(description.toString())  {
                    "맑음" -> "sunny"
                    "구름조금" -> "partially_cloudy"
                    "구름많음" -> "cloudy"
                    "흐림" -> "gloomy"
                    "비" -> "rainy"
                    "소나기" -> "shower"
                    "눈" -> "snow"
                    "안개" -> "foggy"
                    else -> "default_img"
                }
                println(weather_img.toString());

                //ImageView imageView = (ImageView) findViewById(R.id.imageView);
                //imageView.setImageResource(R.drawable.sunny);

            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}