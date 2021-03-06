#! @Chapter Improving and extending the compiler

#! @Section Logic

DeclareGlobalFunction( "CAP_JIT_INTERNAL_TREE_MATCHES_TEMPLATE_TREE" );

#! @Description
#!   Adds the logic template <A>template</A> to the list of logic templates.
#!   For a list of pre-installed logic templates, which can be used as guiding examples, see `CompilerForCAP/gap/LogicTemplates.gi`.
#!   Logic templates are records with the following entries:
#!     * `src_template` and `dst_template` (required): strings containing valid GAP code
#!     * `variable_names` (required): a list of strings
#!     * `variable_filters` (optional): a list of filters with the same length as `variable_names`, defaults to a list of `IsObject`
#!     * `returns_value` (required): a boolean
#!     * `new_funcs` (optional): a list of lists of strings, defaults to the empty list
#!     * `needed_packages` (optional): a list of pairs (i.e. lists with two entries) of strings, defaults to the empty list
#!     * `debug` (optional): a boolean
#!     * `debug_path` (optional): a path
#!
#!   Semantics: `src_template` is a piece of code which should be replaced by `dst_template`:
#!     * The function <Ref Func="CapJitAppliedLogicTemplates" /> tries to find occurences of `src_template` in a tree and
#!       potentially replaces them by `dst_template`.
#!     * When trying to find an occurence of `src_template` in a tree, all strings occuring in the list `variable_names`
#!       are considered as variables, i.e., they match any value in the tree. If a variable occurs
#!       multiple times, the corresponding parts of the tree must be equal.
#!     * <Ref Func="CapJitAppliedLogicTemplates" /> uses <A>jit_args</A> to compute a concrete value of each variable.
#!       The template is only applied if all values match the corresponding filters in `variable_filters`.
#!     * For each function in `dst_template`, <Ref Func="CapJitAppliedLogicTemplates" /> tries to find a corresponding function in
#!       `src_template`. The functions are matched by comparing the lists of names of local variables. If for a function in
#!       `dst_template` no corresponding function in `src_template` exists, you have to add the list of names of local variables
#!       of this function to `new_funcs`.
#!     * `returns_value` must be `true` if `src_template` defines an expression, `false` if it defines a statement.
#!     * `needed_packages` has the same format as `NeededOtherPackages` in `PackageInfo.g`. The template is only evaluated if
#!       the packages in `needed_packages` are loaded in the correct versions.
#!     * `debug` can be set to `true` to print more information while <Ref Func="CapJitAppliedLogicTemplates" /> tries to apply the template.
#!       (Note: this causes informational break loops which are not actual errors).
#!     * `debug_path` can be set to a specific path to get exact information why the subtree at this path does or does not match
#!       `src_template`.
#!
#!    Technical note: `src_template` is only replaced by `dst_template` if the result is well-defined, i.e., if all function variables
#!    reference only functions in their function stack. This can be used to move "static" variables (i.e. variables not depending
#!    on local variables) outside of functions. Example: consider a template with `src_template` given by
#!    `Sum( List( L, x -> x^2 * value ) )` and `dst_template` given by `Sum( List( L, x -> x^2 ) ) * value` (assuming distributivity).
#!    This replacement is only valid if `value` is independent of `x`. However, we do not need to make this explicit at any point,
#!    because if `value` depends on `x`, the result `Sum( List( L, x -> x^2 ) ) * value` is not well-defined,
#!    so the template is not applied anyway.
#! @Arguments template
DeclareGlobalFunction( "CapJitAddLogicTemplate" );

#! @Section Compilation steps

#! @Description
#!   Applies all logic templates (see <Ref Func="CapJitAddLogicTemplate" />) to <A>tree</A>.
#!   The arguments <A>jit_args</A> are used to infer the types of variables.
#!   If the third argument is set to `true`, only templates with empty `dst_template` are applied.
#!   This can be used to quickly drop unwanted statements from the tree without applying all
#!   (possibly expensive) logic templates.
#! @Returns a record
#! @Arguments tree, jit_args[, cleanup_only]
DeclareGlobalFunction( "CapJitAppliedLogicTemplates" );
