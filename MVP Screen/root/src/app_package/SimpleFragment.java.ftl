package ${packageName};
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.annotation.NonNull;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

public class ${fragmentName} extends BaseFragment implements ${contractName}.View {
private ${contractName}.Presenter presenter;

public static ${fragmentName} newInstance(){
return new ${fragmentName}();
}

@Override
    public void onAttach(Context context) {
        super.onAttach(context);
        presenter = new ${name}Presenter(this);
    }


@Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, 
@Nullable ViewGroup container, 
@Nullable Bundle savedInstanceState) {
        return inflater.inflate(R.layout.${layoutFragment}, container, false);
    }

@Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        //toolbar?
    }
}
