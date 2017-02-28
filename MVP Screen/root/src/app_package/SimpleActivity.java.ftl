package ${packageName};
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;

public class ${activityName} extends BaseActivity <#if !generate_fragment> implements
${contractName}.View </#if>{
<#if !generate_fragment>
private ${contractName}.Presenter presenter;
</#if>

    public static void start(Activity activity) {
        Intent intent = new Intent(activity, ${activityName}.class);
        activity.startActivity(intent);
    }
<#if !generate_fragment>

	@Override
    protected void onStart() {
        super.onStart();
        presenter.start();
    }

    @Override
    protected void onStop() {
        super.onStop();
        presenter.stop();
    }

</#if>

<#if !generate_fragment>
	private void initPresenter(){
		 presenter = new ${name}Presenter(this);
	}
</#if>

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
<#if !generate_fragment>
		initPresenter();
</#if>

<#if generate_activity>
        setContentView(R.layout.${layoutActivity});
<#else> 
setContentView(/**@ResLayout*/);
<#if generate_fragment>
        initContentView();
</#if>

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
