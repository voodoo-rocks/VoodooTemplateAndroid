\# VoodooTemplate

Android IDE Template Format
===========================

Format Version
:   4
Last Updated
:   1/30/2014

Overview
--------

This document describes the format and syntax for Android code
templates. These templates provide starting points for entire projects
(e.g. `NewAndroidApplication`) or application components such as
activities (e.g. `BlankActivity`).

Although these templates were originally introduced in the [ADT
Plugin](http://developer.android.com/tools/sdk/eclipse-adt.html) for
Eclipse, the template format is designed for use by any IDE or
command-line tool.

Templates are customizable. Each template exposes several options
(called parameters) that allow developers to customize the generated
code. The most common workflow for *using* a template is as follows:

1.  Choose a template.
2.  Populate template options (parameters).
3.  Preview and then execute the additions/changes to your project.

### FreeMarker

Templates make heavy use of
[FreeMarker](http://freemarker.sourceforge.net/), a Java templating
engine used to enable things like control flows and variable
substitutions inside files. It's similar to PHP, Django templates, etc.
For those more acquainted with C/C++, think of it as a
[preprocessor](http://en.wikipedia.org/wiki/C_preprocessor) language
(i.e. `#ifdef`).

By convention, any file in the template directory structure that is to
be processed by FreeMarker should have the `.ftl` file extension. So if
one of your source files is `MyActivity.java`, and it contains
FreeMarker instructions, it should be named something like
`MyActivity.java.ftl`.

For more documentation on FreeMarker, see the
[docs](http://freemarker.sourceforge.net/docs/index.html). In
particular, the [reference on string
operations](http://freemarker.sourceforge.net/docs/ref_builtins_string.html).

An example, templated version of an Android manifest, normally named
`AndroidManifest.xml.ftl` is shown below.

``` {.prettyprint .lang-xml}
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application>
        <activity android:name="${packageName}.${activityClass}"
            android:parentActivityName="${parentActivityClass}"
            android:label="@string/title_${activityToLayout(activityClass)}">
            <#if parentActivityClass != "">
            <meta-data android:name="android.support.PARENT_ACTIVITY"
                android:value="${parentActivityClass}" />
            </#if>
            <#if isLauncher>
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
            </#if>
        </activity>
    </application>
</manifest>
```

In this example excerpt from the `BlankActivity` template:

-   The expression `${activityClass}` is bound to the value of the
    'Activity Class' template parameter.
-   The expression `${activityToLayout(activityClass)}` uses the
    `activityToLayout` method built into the template engine to convert
    an activity class such as `MyFooActivity` to `activity_my_foo`.
-   The `isLauncher` boolean variable and `parentActivityClass` string
    variables are bound to the values of the 'Launcher Activity' and
    'Hierarchical Parent' template parameter, respectively.

Directory Structure
-------------------

A template is a directory containing a number of XML and FreeMarker
files. The only two mandatory files are `template.xml` and
`recipe.xml.ftl`. Template source files (PNG files, templated Java and
XML files, etc.) belong in a `root/` subdirectory. An example directory
structure for a template is below:

-   **MyTemplate/** — Root directory
    -   [template.xml](#toc_templatexml) — Metadata (description,
        parameters, etc.)
    -   [recipe.xml.ftl](#toc_recipexmlftl) — Instructions/script (files
        to copy, etc.)
    -   [globals.xml.ftl](#toc_globalsxmlftl)— Optional global variables
    -   template.png — Default template thumbnail
    -   template\_foo.png — Thumbnail when option 'foo' is selected
    -   template\_bar.png
    -   **[root/](#toc_root)** — Source files (which get
        processed/copied/merged with the output project)
        -   AndroidManifest.xml.ftl
        -   **res/**
            -   …
        -   **src/**
            -   **app\_package/**
                -   MyActivity.java.ftl

\

More on the role of each of these files is discussed in the sections
below.

### template.xml

Each template directory must contain a `template.xml` file. This XML
file contains metadata about the template, including the name,
description, category and user-visible parameters that the IDE will
present as options to the user. The XML file also indicates the name of
the [recipe XML file](#toc_recipexmlftl) (which gets processed by
FreeMarker), and the [global variables XML file](#toc_globalsxmlftl) if
there are global variables besides the template parameter values that
should be visible to all FreeMarker-processed files (`.ftl` files).

An example `template.xml` is shown below.

``` {.prettyprint .lang-xml}
<!-- A template for a blank activity. Use template format
     version 4, as described in this document. -->
<template
    format="4"
    revision="2"
    minApi="7"
    minBuildApi="16"
    name="Blank Activity"
    description="Creates a new blank activity, with navigation.">
    <!-- A string parameter; the value is available to FreeMarker
         processed files (.ftl files) as ${activityName}. -->
    <parameter
        id="activityClass"
        name="Activity Name"
        type="string"
        constraints="class|unique|nonempty"
        suggest="${layoutToActivity(layoutName)}"
        default="MainActivity"
        help="The name of the activity class to create." />
    <parameter
        id="layoutName"
        name="Layout Name"
        type="string"
        constraints="layout|unique|nonempty"
        suggest="${activityToLayout(activityClass)}"
        default="activity_main"
        help="The name of the layout to create for the activity" />
    <parameter
        id="navType"
        name="Navigation Type"
        type="enum"
        default="none"
        help="The type of navigation to use for the activity">
        <option id="none">None</option>
        <option id="tabs" minApi="11">Tabs</option>
        <option id="pager" minApi="11">Swipe Views</option>
        <option id="dropdown" minApi="11">Dropdown</option>
    </parameter>
    <parameter
        id="fragmentName"
        name="Fragment Name"
        type="string"
        constraints="class|unique|nonempty"
        default="MainFragment"
        visibility="navType != 'none'"
        help="The name of the fragment class to create" />
    <!-- 512x512 PNG thumbnails. -->
    <thumbs>
        <!-- Default thumbnail. -->
        <thumb>template_default.png</thumb>
        <!-- Attributes act as selectors based on chosen parameters. -->
        <thumb navType="tabs">template_tabs.png</thumb>
        <thumb navType="dropdown">template_dropdown.png</thumb>
    </thumbs>
    <!-- Optional global variables. -->
    <globals file="globals.xml.ftl" />
    <!-- Required recipe (script) to run when instantiating
         the template. -->
    <execute file="recipe.xml.ftl" />
</template>
```

Below is a listing of supported tags in `template.xml`.

#### \<template\> {.includetoc}

The template root element.

`format`
:   The template format version that this template adheres to. Should be
    `4`.
`revision`
:   Optional. The version of this template (which you can increment when
    updating the template), as an integer.
`name`
:   The template's display name.
`description`
:   The template's description.
`minApi`
:   Optional. The minimum API level required for this template. The IDE
    will ensure that the target project has a `minSdkVersion` no lower
    than this value before instantiating the template.
`minBuildApi`
:   Optional. The minimum build target (expressed as an API level)
    required for this template. The IDE will ensure that the target
    project is targeting an API level greater than or equal to this
    value before instantiating the template. This ensures that the
    template can safely use newer APIs (optionally guarded by runtime
    API level checks) without introducing compile-time errors into the
    target project.

#### \<dependency\> {.includetoc}

This tag is deprecated for use in `template.xml`. Use
[`<dependency>`](#toc_recipe_dependency) in `recipe.xml.ftl` instead.

Indicates that the template requires that a given library be present in
the target project. If not present, the IDE will add the dependency to
the project.

`name`
:   The name of the library. Currently accepted values are:
    -   `android-support-v4`
    -   `android-support-v13`

`revision`
:   The minimum revision of the library required by this template.

#### \<category\> {.includetoc}

The template type. This element is optional.

`value`
:   The template type. Should be one of the following values:
    -   `Applications`
    -   `Activities`
    -   `UI Components`

#### \<parameter\> {.includetoc}

Defines a user-customizable template parameter.

`id`
:   The identifier representing this variable, made available as a
    global variable in FreeMarker files. If the identifier is `foo`, the
    parameter value will be available in FreeMarker files as `${foo}`.
`name`
:   The display name of the template parameter.
`type`
:   The data type of the parameter. Either `string`, `boolean`, `enum`,
    or `separator`.
`constraints`
:   Optional. Constraints to impose on the parameter's value.
    Constraints can be combined using `|`. Valid constraint types are:
    -   `nonempty` — the value must not be empty
    -   `apilevel` — the value should represent a numeric API level
    -   `package` — the value should represent a valid Java package name
    -   `app_package` — the value should represent a valid Android app
        package name
    -   `module` — the value should represent a valid Module name
    -   `class` — the value should represent a valid Java class name
    -   `activity` — the value should represent a fully-qualified
        activity class name
    -   `layout` — the value should represent a valid layout resource
        name
    -   `drawable` — the value should represent a valid drawable
        resource name
    -   `string` — the value should represent a valid string resource
        name
    -   `id` — the value should represent a valid id resource name
    -   `unique` — the value must be unique; this constraint only makes
        sense when other constraints are specified, such as `layout`,
        which would mean that the value should not represent an existing
        layout resource name
    -   `exists` — the value must already exist; this constraint only
        makes sense when other constraints are specified, such as
        `layout`, which would mean that the value should represent an
        existing layout resource name

`suggest`
:   Optional. A FreeMarker expression representing the auto-suggested
    parameter value (a 'dynamic default'). When the user modifies other
    parameter values, and if this parameter's value has not been changed
    from its default, then the value changes to the result of this
    expression. This may seem to be circular since parameters can
    `suggest` against each other's values, but these expressions are
    only updated for non-edited values, so this approach lets the user
    edit either parameter value, and the other will automatically be
    updated to a reasonable default.
`default`
:   Optional. The default value for this parameter.
`visibility`
:   Optional. A FreeMarker expression that determines whether this
    parameter should be visible. The expression should evaluate to a
    boolean value (i.e. true or false).
`help`
:   Optional. The help string to display to the user for this parameter.

#### \<option\> {.includetoc}

For parameters of type `enum`, represents a choice for the value.

`id`
:   The parameter value to set if this option is chosen.
`minApi`
:   Optional. The minimum API level required if this option is chosen.
    The IDE will ensure that the target project has a `minSdkVersion` no
    lower than this value before instantiating the template.
`[text]`
:   The text content of this element represents the display value of the
    choice.

#### \<thumb\> {.includetoc}

Represents a thumbnail for the template. `<thumb>` elements should be
contained inside a `<thumbs>` element. The text contents of this element
represent the path to the thumbnail. If this element has any attributes,
they will be treated as selectors for parameter values. For example, if
there are two thumbnails:

``` {.prettyprint .lang-xml}
<thumbs>
  <thumb>template.png</thumb>
  <thumb navType="tabs">template_tabs.png</thumb>
</thumbs>
```

The template 'preview' thumbnail will show `template_tabs.png` if the
value of the `navType` template parameter is `tabs` and `template.png`
otherwise.

#### \<icons\> {.includetoc}

States that the template would like the Asset Studio icon creation tool
of the given type to run, and save the output icons with the given name.

`type`
:   The type of icon wizard to create. Valid values are `notification`,
    `actionbar`, `launcher`.
`name`
:   The base icon name to output, e.g. `ic_stat_my_notification`.

### globals.xml.ftl

The optional globals XML file contains global variable definitions, for
use in all FreeMarker processing jobs for this template.

An example `globals.xml.ftl` is shown below.

``` {.prettyprint .lang-xml}
<globals>
    <global id="srcOut"
            value="src/${slashedPackageName(packageName)}" />
    <global id="activityNameLower"
            value="${activityName?lower_case}" />
    <global id="activityClass"
            value="${activityName}Activity" />
</globals>
```

### recipe.xml.ftl

The recipe XML file contains the individual instructions that should be
executed when generating code from this template. For example, you can
copy certain files or directories (the copy instruction), optionally
running the source files through FreeMarker (the instantiate
instruction), and ask the IDE to open a file after the code has been
generated (the open instruction).

**Note:** The name of the recipe file is up to you, and is defined in
`template.xml`. By convention, however, it's best to call it
`recipe.xml.ftl`.

**Note:** The global variables in `globals.xml.ftl` are available for
use in `recipe.xml.ftl`.

An example `recipe.xml.ftl` is shown below.

``` {.prettyprint .lang-xml}
<recipe>
    <#if appCompat?has_content>
    <dependency mavenUrl="com.android.support:appcompat-v7:+"/>
    </#if>
    <!-- runs FreeMarker, then copies from
         [template-directory]/root/ to [output-directory],
         automatically creating directories as needed. -->
    <merge from="AndroidManifest.xml.ftl"
             to="${escapeXmlAttribute(manifestDir)}/AndroidManifest.xml" />
    <!-- simply copy file, don't run FreeMarker -->
    <copy from="res/drawable-mdpi"
            to="${escapeXmlAttribute(resDir)}/res/drawable-mdpi" />
    <copy from="res/drawable-hdpi"
            to="${escapeXmlAttribute(resDir)}/res/drawable-hdpi" />
    <copy from="res/drawable-xhdpi"
            to="${escapeXmlAttribute(resDir)}/res/drawable-xhdpi" />
    <copy from="res/drawable-xxhdpi"
            to="${escapeXmlAttribute(resDir)}/res/drawable-xxhdpi" />
    <copy from="res/menu/main.xml"
            to="${escapeXmlAttribute(resDir)}/res/menu/${activityNameLower}.xml" />
    <!-- run FreeMarker and then merge with existing files -->
    <merge from="res/values/dimens.xml"
             to="${escapeXmlAttribute(resDir)}/res/values/dimens.xml" />
    <merge from="res/values-large/dimens.xml"
             to="${escapeXmlAttribute(resDir)}/res/values-large/dimens.xml" />
    <merge from="res/values/styles.xml"
             to="${escapeXmlAttribute(resDir)}/res/values/styles.xml" />
    <merge from="res/values/strings.xml.ftl"
             to="${escapeXmlAttribute(resDir)}/res/values/strings.xml" />
    <!-- Decide which layout to add -->
    <#if navType?contains("pager")>
        <instantiate
            from="${escapeXmlAttribute(resDir)}/res/layout/activity_pager.xml.ftl"
              to="${escapeXmlAttribute(resDir)}/res/layout/activity_${activityNameLower}.xml" />
    <#elseif navType == "tabs" || navType == "dropdown">
        <copy from="${escapeXmlAttribute(resDir)}/res/layout/activity_fragment_container.xml"
                to="${escapeXmlAttribute(resDir)}/res/layout/activity_${activityNameLower}.xml" />
    <#else>
        <copy from="${escapeXmlAttribute(resDir)}/res/layout/activity_simple.xml"
                to="${escapeXmlAttribute(resDir)}/res/layout/activity_${activityNameLower}.xml" />
    </#if>
    <!-- Decide which activity code to add -->
    <#if navType == "none">
        <instantiate from="src/app_package/SimpleActivity.java.ftl"
                       to="${escapeXmlAttribute(srcOut)}/${activityClass}.java" />
    <#elseif navType == "pager">
        <instantiate from="src/app_package/PagerActivity.java.ftl"
                       to="${escapeXmlAttribute(srcOut)}/${activityClass}.java" />
    <#elseif navType == "tabs">
        <instantiate from="src/app_package/TabsActivity.java.ftl"
                       to="${escapeXmlAttribute(srcOut)}/${activityClass}.java" />
    <#elseif navType == "dropdown">
        <instantiate from="src/app_package/DropdownActivity.java.ftl"
                       to="${escapeXmlAttribute(srcOut)}/${activityClass}.java" />
    </#if>
    <!-- open the layout file and Java class when done -->
    <open file="${escapeXmlAttribute(resDir)}/res/layout/${activityNameLower}.xml" />
    <open file="${escapeXmlAttribute(srcOut)}/${activityClass}.java" />
</recipe>
```

The instructions below are supported:

#### \<dependency\> {.includetoc data-tocid="recipe_dependency"}

Indicates that the template requires that a given library be present in
the target project. If not present, the IDE will add the dependency to
the project.

`mavenUrl`
:   The maven coordinates of the library. For example,
    `com.android.support:appcompat-v7:+`

#### \<copy\> {.includetoc}

The only required argument is `from` which specifies the location of the
source files to copy under the `root/` directory. All necessary ancestor
directories are automatically created if needed.

The default destination location is the same path under the output
directory root (i.e. the location of the destination project). If the
optional `to` argument is provided, this specifies the output directory.
Note that if the from path ends with `.ftl`, it will automatically be
stripped. For example
`<instantiate from="res/values/strings.xml.ftl" />` is adequate; this
will create a file named `strings.xml`, not `strings.xml.ftl`.

This argument works recursively, so if `from` is a directory, that
directory is recursively copied.

#### \<instantiate\> {.includetoc}

Same as `<copy>`, but each source file is first run through FreeMarker.

#### \<merge\> {.includetoc}

This instruction will run the source file through FreeMarker and then
merge the contents of the output into an existing file in the project,
or create a new file. The most common use case for this is to add
components to the `AndroidManifest.xml` file of the destination project,
or to merge resources such as strings into an existing `strings.xml`
file.

#### \<open\> {.includetoc}

Instruct the IDE to open the file created by the specified `file`
argument after code generation is complete.

#### \<mkdir\> {.includetoc}

Ensures the directory provided in the `at` argument exists.

### root/

The actual template files (resources, Java sources, Android Manifest
changes) should be placed in the `root/` directory, in a directory
structure that roughly resembles what the output directory structure
should look like.

One difference is that instead of placing source files in
`src/com/google/...` you can just use a naming convention like
`src/app_package/` to indicate that files under this directory will be
placed in the destination project's source file package root.

Built-in Template Functions
---------------------------

Several functions are available to FreeMarker expressions and files
beyond the standard set of built-in FreeMarker functions. These are
listed below.

### string *activityToLayout*(string) {data-toctitle="activityToLayout"}

This function converts an activity class-like identifer string, such as
`FooActivity`, to a corresponding resource-friendly identifier string,
such as `activity_foo`.

#### Arguments

`activityClass`
:   The activity class name, e.g. `FooActivity` to reformat.

#### See also

[`layoutToActivity`](#toc_layouttoactivity)

### string *camelCaseToUnderscore*(string) {data-toctitle="camelCaseToUnderscore"}

This function converts a camel-case identifer string, such as `FooBar`,
to its corresponding underscore-separated identifier string, such as
`foo_bar`.

#### Arguments

`camelStr`
:   The camel-case string, e.g. `FooBar` to convert to an
    underscore-delimited string.

#### See also

[`underscoreToCamelCase`](#toc_underscoretocamelcase)

### string *escapePropertyValue*(string) {data-toctitle="escapePropertyValue"}

This function escapes a string, such as `foo=bar` such that it is
suitable to be inserted in a Java `.properties` file as a property
value, such as `foo\=bar`.

#### Arguments

`str`
:   The string, e.g. `foo=bar` to escape to a proper property value.

### string *escapeXmlAttribute*(string) {data-toctitle="escapeXmlAttribute"}

This function escapes a string, such as `Android's` such that it can be
used as an XML attribute value: `Android&apos;s`. In particular, it will
escape ', ", \< and &.

#### Arguments

`str`
:   The string to be escaped.

#### See also

[`escapeXmlText`](#toc_escapexmltext)

[`escapeXmlString`](#toc_escapexmlstring)

### string *escapeXmlText*(string) {data-toctitle="escapeXmlText"}

This function escapes a string, such as `A & B's` such that it can be
used as XML text. This means it will escape \< and \>, but unlike
[`escapeXmlAttribute`](#toc_escapexmlattribute) it will **not** escape '
and ". In the preceeding example, it will escape the string to
`A &amp; B\s`. Note that if you plan to use the XML text as the value
for a \<string\> resource value, you should consider using
[`escapeXmlString`](#toc_escapexmlstring) instead, since it performs
additional escapes necessary for string resources.

#### Arguments

`str`
:   The string to escape to proper XML text.

#### See also

[`escapeXmlAttribute`](#toc_escapexmlattribute)

[`escapeXmlString`](#toc_escapexmlstring)

### string *escapeXmlString*(string) {data-toctitle="escapeXmlString"}

This function escapes a string, such as `A & B's` such that it is
suitable to be inserted in a string resource file as XML text, such as
`A &amp; B\s`. In addition to escaping XML characters like \< and &, it
also performs additional Android specific escapes, such as escaping
apostrophes with a backslash, and so on.

#### Arguments

`str`
:   The string, e.g. `Activity's Title` to escape to a proper resource
    XML value.

#### See also

[`escapeXmlAttribute`](#toc_escapexmlattribute)

[`escapeXmlText`](#toc_escapexmltext)

### string *extractLetters*(string) {data-toctitle="extractLetters"}

This function extracts all the letters from a string, effectively
removing any punctuation and whitespace characters.

#### Arguments

`str`
:   The string to extract letters from

### string *classToResource*(string) {data-toctitle="classToResource"}

This function converts an Android class name, such as `FooActivity` or
`FooFragment`, to a corresponding resource-friendly identifier string,
such as `foo`, stripping the 'Activity' or 'Fragment' suffix. Currently
stripped suffixes are listed below.

-   Activity
-   Fragment
-   Provider
-   Service

#### Arguments

`className`
:   The class name, e.g. `FooActivity` to reformat as an
    underscore-delimited string with suffixes removed.

#### See also

[`activityToLayout`](#toc_activitytolayout)

### string *layoutToActivity*(string) {data-toctitle="layoutToActivity"}

This function converts a resource-friendly identifer string, such as
`activity_foo`, to a corresponding Java class-friendly identifier
string, such as `FooActivity`.

#### Arguments

`resourceName`
:   The resource name, e.g. `activity_foo` to reformat.

#### See also

[`activityToLayout`](#toc_activitytolayout)

### string *slashedPackageName*(string) {data-toctitle="slashedPackageName"}

This function converts a full Java package name to its corresponding
directory path. For example, if the given argument is `com.example.foo`,
the return value will be `com/example/foo`.

#### Arguments

`packageName`
:   The package name to reformat, e.g. `com.example.foo`.

### string *underscoreToCamelCase*(string) {data-toctitle="underscoreToCamelCase"}

This function converts an underscore-delimited string, such as
`foo_bar`, to its corresponding camel-case string, such as `FooBar`.

#### Arguments

`underStr`
:   The underscore-delimited string, e.g. `foo_bar` to convert to a
    camel-case string.

#### See also

[`camelCaseToUnderscore`](#toc_camelcasetounderscore)

Built-in Template Parameters
----------------------------

Several parameters are available to FreeMarker expressions and files
beyond [those defined by the template](#toc_parameter). These are listed
below.

### packageName

The Java-style Android package name for the project, e.g.
`com.example.foo`

### applicationPackage

Will be the application package (i.e. the package name declared in the
app manifest) if the target package for this template is not the
application package. Otherwise, this parameter will be empty.

### isNewProject

A boolean indicating whether or not this template is being instantiated
as part of a New Project flow.

### minApi

The minimum API level the project supports. Note that this value could
be a string so consider using [`minApiLevel`](#toc_minapilevel) instead.

### minApiLevel

The minimum API level the project supports, guaranteed to be a number.
This is generally used to guard the generation of code based on the
project's API level, for example:

    int drawableResourceId = android.R.layout.simple_list_item_<#if minApiLevel gte 11>activated_</#if>_1;

### buildApi

The API level that the project is building against, guaranteed to be a
number. This is generally used to guard the generation of code based on
what version of the Android SDK the project is being built against, for
example:

    <TextView android:layout_width="wrap_content"
        android:layout_height="<#if buildApi gte 8>match_parent<#else>fill_parent</#if>" />

### manifestDir

The target output directory for the `AndroidManifest.xml` file. This
varies depending on the project's directory structure (Gradle-style or
Ant-style).

### srcDir

The target Java source root directory for the project. This varies
depending on the project's directory structure (Gradle-style or
Ant-style). It's common to concatenate the package name:

    ${srcDir}/${slashedPackageName(packageName)}

#### See also

[`slashedPackageName`](#toc_slashedpackagename)

### resDir

The target resource directory root (`res/` folder) for the project. This
varies depending on the project's directory structure (Gradle-style or
Ant-style).

Notes for Template Authors
--------------------------

### Tools metadata

When creating activity layouts, make sure to include the activity name
in the root view in the layout as part of the `tools` namespace, as
shown in the following example:

``` {.prettyprint .lang-xml}
<TextView xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:gravity="center"
    android:text="@string/hello_world"
    android:padding="@dimen/padding_medium"
    tools:context=".${activityClass}" />
```

As of ADT 20 we use this attribute in layouts to maintain a mapping to
the active activity to use for a layout. (Yes, there can be more than
one, but this attribute is showing the activity context you want to edit
the layout as. For example, it will be used to look up a theme
registration (which is per-activity rather than per-layout) in the
manifest file, and we will use this for other features in the future—for
example to preview the action bar, which also requires us to know the
activity context.
