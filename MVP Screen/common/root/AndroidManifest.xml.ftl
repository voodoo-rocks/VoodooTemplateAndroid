<manifest xmlns:android="http://schemas.android.com/apk/res/android" >
    <application>
<#if generate_activity>
        <activity android:name="${relativePackage}.${activityName}"
            android:screenOrientation="portrait"
            android:windowSoftInputMode="stateHidden"/>
</#if>
    </application>
</manifest>
