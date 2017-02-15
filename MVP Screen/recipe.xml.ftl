<?xml version="1.0"?>
<recipe>
<#include "./common/recipe_manifest.xml.ftl" />

    <open file="${escapeXmlAttribute(srcOut)}/${contractName}.java" />

    <instantiate from="root/src/app_package/SimpleContract.java.ftl"
                   to="${escapeXmlAttribute(srcOut)}/${contractName}.java" />

    <open file="${escapeXmlAttribute(srcOut)}/${fragmentName}.java" />
<#if generate_fragment>
    <instantiate from="root/src/app_package/SimpleFragment.java.ftl"
                   to="${escapeXmlAttribute(srcOut)}/${fragmentName}.java" />

<instantiate from="root/res/layout/fragment_simple.xml"
                 to="${escapeXmlAttribute(resOut)}/layout/${layoutFragment}.xml" />
</#if>

    <open file="${escapeXmlAttribute(srcOut)}/${activityName}.java" />
<#if generate_activity>
    <instantiate from="root/src/app_package/SimpleActivity.java.ftl"
                   to="${escapeXmlAttribute(srcOut)}/${activityName}.java" />

<instantiate from="root/res/layout/activity_simple.xml"
                 to="${escapeXmlAttribute(resOut)}/layout/${layoutActivity}.xml" />
</#if>

<open file="${escapeXmlAttribute(srcOut)}/${presenterName}.java" />

    <instantiate from="root/src/app_package/SimplePresenter.java.ftl"
                   to="${escapeXmlAttribute(srcOut)}/${presenterName}.java" />

</recipe>
