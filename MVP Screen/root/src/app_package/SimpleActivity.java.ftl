package ${packageName};
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;

public class ${activityName} extends BaseActivity <#if !generate_fragment><#if generate_controller> implements ${contractName}.View </#if></#if> {
<#if !generate_fragment>
    private ${contractName}.Presenter presenter;
</#if>
<#if generate_controller>
    private Router router;
</#if>

    public static void start(Activity activity) {
        Intent intent = new Intent(activity, ${activityName}.class);
        activity.startActivity(intent);
    }
<#if !generate_fragment>
<#if !generate_controller>
    @Override
    protected void onStop() {
        super.onStop();
        presenter.stop();
    }
</#if>
</#if>

<#if !generate_fragment>
<#if !generate_controller>
	private void initPresenter(){
		 presenter = new ${name}Presenter(this);
	}
</#if>
</#if>

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
<#if !generate_fragment>
<#if !generate_controller>
		initPresenter();
</#if>
</#if>

<#if generate_activity>
        setContentView(R.layout.${layoutActivity});
</#if> 
<#if generate_fragment>
        initContentView();
</#if>

<#if generate_controller>
    router = Conductor.attachRouter(this, container, savedInstanceState);
    if(!router.hasRootController()){
        ${controllerName}.attachToRouter(router);
    }
</#if>
    }
<#if generate_fragment>
    private void initContentView() {
        ${fragmentName} fragment = (${fragmentName}) getSupportFragmentManager()
                .findFragmentByTag(${fragmentName}.class.getSimpleName());

        if (fragment == null) {
            fragment = ${fragmentName}.newInstance();
            new ${name}Presenter(fragment);
            showFragment(R.id.container_view_group, fragment);
        }
    }
</#if>
}
