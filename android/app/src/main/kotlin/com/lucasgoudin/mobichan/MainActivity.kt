package com.lucasgoudin.mobichan

import io.flutter.embedding.android.FlutterActivity
import androidx.core.view.WindowCompat
import android.os.Build

class MainActivity: FlutterActivity() {
    override fun onPostResume() {
        super.onPostResume()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            WindowCompat.setDecorFitsSystemWindows(window, false)
            window.navigationBarColor = 0
        }
    }
}
