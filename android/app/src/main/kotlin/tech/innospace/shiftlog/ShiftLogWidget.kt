package tech.innospace.shiftlog

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class ShiftLogWidget : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        appWidgetIds.forEach { id ->
            val views = RemoteViews(context.packageName, R.layout.shiftlog_widget).apply {
                setTextViewText(
                    R.id.widget_duration,
                    widgetData.getString("duration", "0h 00m"),
                )
                setTextViewText(
                    R.id.widget_status,
                    widgetData.getString("status", "Not clocked in"),
                )
                setTextViewText(
                    R.id.widget_button,
                    widgetData.getString("button", "Sign In"),
                )

                // Button → background toggle (no app UI).
                val toggle = HomeWidgetBackgroundIntent.getBroadcast(
                    context,
                    Uri.parse("shiftlog://toggle"),
                )
                setOnClickPendingIntent(R.id.widget_button, toggle)

                // Tapping the rest of the widget opens the app.
                val open = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java,
                )
                setOnClickPendingIntent(R.id.widget_duration, open)
                setOnClickPendingIntent(R.id.widget_label, open)
            }
            appWidgetManager.updateAppWidget(id, views)
        }
    }
}
