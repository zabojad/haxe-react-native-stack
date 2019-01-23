---
---
# Forms in your app

Handling user text inputs is a need common to most apps. There is probably as many ways to implement it as there is developers out there.

It is nevertheless a sensible part of your app as it is a door that will provide your entire system with data.

We thus think it can be necessary to provide a recommended way to implement forms.

Let's take the exemple of an basic contact list where we add/edit contacts. In that app, we will have a `ContactForm` which will be used for both creating a new `Contact` as well as editing it. 

First things first, we will need to design the shape of our form. This starts with its data:

```haxe
// src/myapp/view/form/ContactForm.hx
package myapp.view.form;

typedef ContactFormShape={
    firstname:String,
    lastname:String,
    phone:String,
    email:String
}
```

Then we will need a view component with inputs. In this example, we will use the React native API over the React js. If you are not yet familiar with it, checkout the [RN part of this documentation](haxe_react_native).

```haxe
// src/myapp/view/form/ContactForm.hx
package myapp.view.form;

import react.ReactComponent;
import react.ReactMacro.jsx;
import react.Partial;

import react.native.component.*;
import react.native.api.*;

// ...

typedef ContactFormProps={
    intl:IntlShape,
    ?defaultValue:ContactFormShape, // in case of editing an existing Contact, we will pass some value here
    // ...
}
typedef ContactFormState={
    value:ContactFormShape
}
class ContactForm extends ReactComponentOf<ContactFormProps, ContactFormState> {

    static var _dv : ContactFormShape = 
        {
            firstname:'',
            lastname:'',
            phone:'',
            email:''
        }

    function new(p : ContactFormProps) {
        super(p);
        var dv = p.defaultValue;
        if (dv == null) {
            dv = _dv;
        }
        this.state = { value: dv }
    }

    function setStateFirstname(st : ContactFormState, p : ContactFormProps, v : Null<String>) : Partial<ContactFormState> {
        var v = js.Object.assign({}, st.value, { firstname: v });
        return { value: v };
    }
    function setFirstname(v : String) {
        setState(setStateFirstname.bind(_,_,v));
    }

    function setStateLastname(st : ContactFormState, p : ContactFormProps, v : Null<String>) : Partial<ContactFormState> {
        var v = js.Object.assign({}, st.value, { lastname: v });
        return { value: v };
    }
    function setLastname(v : String) {
        setState(setStateLastname.bind(_,_,v));
    }

    function setStatePhone(st : ContactFormState, p : ContactFormProps, v : Null<String>) : Partial<ContactFormState> {
        var v = js.Object.assign({}, st.value, { phone: v });
        return { value: v };
    }
    function setPhone(v : String) {
        setState(setStatePhone.bind(_,_,v));
    }

    function setStateEmail(st : ContactFormState, p : ContactFormProps, v : Null<String>) : Partial<ContactFormState> {
        var v = js.Object.assign({}, st.value, { email: v });
        return { value: v };
    }
    function setEmail(v : String) {
        setState(setStateEmail.bind(_,_,v));
    }

    function onSubmit() {
        var value : ContactFormShape = state.value;
        props.onSubmit(value);
    }

    override function render() {
        var plhd_01 = props.intl.formatMessage({ id: "placeholder_firstname" });
        var plhd_02 = props.intl.formatMessage({ id: "placeholder_lastname" });
        var plhd_03 = props.intl.formatMessage({ id: "placeholder_phone" });
        var plhd_04 = props.intl.formatMessage({ id: "placeholder_email" });
        return jsx('
            <View>
                <View>
                    <TextInput
                        onChangeText=${setFirstname}
                        placeholder=${plhd_01}
                        value=${state.value.firstname}
                    />
                </View>
                <View>
                    <TextInput
                        onChangeText=${setLastname}
                        placeholder=${plhd_01}
                        value=${state.value.lastname}
                    />
                </View>
                <View>
                    <TextInput
                        onChangeText=${setPhone}
                        placeholder=${plhd_01}
                        value=${state.value.phone}
                    />
                </View>
                <View>
                    <TextInput
                        onChangeText=${setEmail}
                        placeholder=${plhd_01}
                        value=${state.value.email}
                    />
                </View>
                <TouchableOpacity
                    onPress={onSubmit}
                >
                    <FormattedMessage id="btn_submit" />
                </TouchableOpacity>
            </View>
        ');
    }
}
```

Now that we have a view component and a state shape, we will need a way to handle all the input mistakes our users could make using this form. To do so, we add two things:
- an error state shape,
- validation logic on the value state shape.

Both those features can be added elegantly in the shapes models using [abstract types](https://haxe.org/manual/types-abstract.html){:target="_blank"}. It is not an obligation, it's just some nice way to write it. Using static utils classes would have been as good as this.

```haxe
// src/myapp/view/form/ContactForm.hx
package myapp.view.form;

import myapp.util.Sanitizer.cleanString; // utils implementing simple sanitizing tasks on Strings
import myapp.util.Validators.isNotEmpty; // utils implementing simple validation tasks on Strings

// ...

@:forward
abstract ContactFormShape(ContactFormShapeImpl)
    from ContactFormShapeImpl to ContactFormShapeImpl{
    static var _requiredFields : Array<String> =
        [
            "firstname",
            "lastname",
            "phone"
        ];

    public function sanitize() : ContactFormShape {
        var fs : ContactFormShape = js.Object.assign({},this);
        fs.firstname = cleanString(fs.firstname);
        fs.lastname = cleanString(fs.lastname);
        fs.phone = cleanString(fs.phone);
        fs.email = cleanString(fs.email);
        return fs;
    }

    public function validate() : ContactFormErrors {
        var ret : ContactFormErrors = { __errors: false };
        for (f in _requiredFields) {
            if (!isNotEmpty(Reflect.field(this,f))) {
                Reflect.setField(ret,f,"form_required");
                ret.__errors = true;
            }
        }
        if (!isEmail(this.email)) {
            ret.email = "email_expected";
            ret.__errors = true;
        }
        if (!isPhone(this.phone)) {
            ret.phone = "phone_expected";
            ret.__errors = true;
        }
        return ret;
    }
}
typedef ContactFormShapeImpl={
    firstname:String,
    lastname:String,
    phone:String,
    email:String,
}

@:forward
abstract ContactFormErrors(ContactFormErrorsImpl)
    from ContactFormErrorsImpl to ContactFormErrorsImpl{

    public function getNextError() : Null<String> {
        if (this.__form != null) return this.__form;
        for (k in Reflect.fields(this)) {
            if (k != "__errors" && Reflect.field(this,k) != null) {
                return Reflect.field(this,k);
            }
        }
        return null;
    }
}
typedef ContactFormErrorsImpl={
    firstname:String,
    lastname:String,
    phone:String,
    email:String,
    __errors : Bool,
    ? __form : String,
}

typedef ContactFormState={
    // ...
    ?errors:ContactFormErrors,
}

// ...

class ContactForm extends ReactComponentOf<ContactFormProps, ContactFormState> {

    // ...

    function new(p : ContactFormProps) {
        // ...
        this.state = { value: dv, errors: { __errors: false } };
    }

    // ...

    override function componentDidUpdate(pp : ContactFormProps, ps : ContactFormState) : Void {
        if (ps.errors != state.errors && state.errors.__errors) {
            var msg : String = state.errors.getNextError();
            // ToastAndroid is just a suggestion, use whatever you want to display the error message to the user
            ToastAndroid.showWithGravity(
                props.intl.formatMessage({ id: msg }),
                ToastAndroid.LONG,
                ToastAndroid.BOTTOM
            );
        }
    }

    function setStateErrors(st : ContactFormState, p : ContactFormProps, errors : ContactFormErrors) : Partial<ContactFormState> {
        return { errors: errors };
    }

    // ...

    function onSubmit() {
        var errors : Null<ContactFormErrors> = null;
        var value : ContactFormShape = state.value.sanitize();
        errors = value.validate();
        setState({ value: value, errors: errors });
        if (!errors.__errors) {
            props.onSubmit(value);
        }
    }
    
    // ...

}
```

In case we have sever side validation, we can manage it with a [derived state](https://reactjs.org/docs/react-component.html#static-getderivedstatefromprops){:target="_blank"}:

```haxe
// src/myapp/view/form/ContactForm.hx

// ...

import myapp.dto.ApiError; 

// ...

@:forward
abstract ContactFormErrors(ContactFormErrorsImpl)
    from ContactFormErrorsImpl to ContactFormErrorsImpl{

    // ...

    @:from
    static public function fromApiError(v : APIError) : ContactFormErrors {
        return {
            __errors: true,
            __form: v.message,
        }
    }
}

// ...

typedef ContactFormProps={
    // ...
    ?apiError:ApiError,
}

class ContactForm extends ReactComponentOf<ContactFormProps, ContactFormState> {

    // ...

    static function getDerivedStateFromProps(np:ContactFormProps,cs:ContactFormState):Partial<ContactFormState> {
        if (np.errors != null){
            var ns :Partial<ContactFormState>  = {
                errors: np.errors,
            }
            return ns;
        }
        return null;
    }

    // ...
}
```

Now if we come back to the form value state shape, we can assume that we will very probably need to be converted somehow from and to some dto value. This can be achieved the same way with abstract `@:from` and `@:to` functions:

```haxe
// src/myapp/view/form/ContactForm.hx

// ...

abstract ContactFormShape(ContactFormShapeImpl)
    from ContactFormShapeImpl to ContactFormShapeImpl{

    @:from
    static public function fromContact(v : myapp.dto.Contact) : ContactFormShape {
        var r : ContactFormShape =
            {
                firstname: v.firstname,
                lastname: v.lastname,
                phone: v.phone,
                email: v.email,
            }
        return r;
    }

    @:to
    public function toContact() : Partial<myapp.dto.Contact> {
        var r : Partial<myapp.dto.Contact> =
            {
                firstname: this.firstname,
                lastname: this.lastname,
                phone: this.phone,
                email: this.email,
            }
        return r;
    }

    // ...
}

// ...
```
