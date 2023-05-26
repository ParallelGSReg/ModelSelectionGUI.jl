using Dates

mutable struct ModelSelectionJob
    id::String
    file::String
    hash::String
    parameters::Dict{Symbol, Any}
    time_enqueued::DateTime
    time_started::Union{DateTime, Nothing}
    time_finished::Union{DateTime, Nothing}
    modelselection_data::Union{ModelSelection.ModelSelectionData, Nothing}

    function ModelSelectionJob(file::String, hash::String, raw_parameters::Dict{String,Any})
        parameters = Dict{Symbol,Any}()
        parameters[:estimator] = raw_payload[:estimator]
        parameters[:equation] = raw_payload[:equation]
        parameters[:method] = :method in raw_parameters[:method] ? raw_parameters[:method][:method] : Preprocessing.METHOD_DEFAULT
        parameters[:intercept] = :intercept in raw_parameters[:method] ? raw_parameters[:method][:intercept] : Preprocessing.INTERCEPT_DEFAULT
        parameters[:panel] = :panel in raw_parameters[:method] ? raw_parameters[:method][:panel] : Preprocessing.PANEL_DEFAULT
        parameters[:time] = :time in raw_parameters[:method] ? raw_parameters[:method][:time] : Preprocessing.TIME_DEFAULT
        parameters[:seasonaladjustment] = :seasonaladjustment in raw_parameters[:method] ? raw_parameters[:method][:seasonaladjustment] : Preprocessing.SEASONALADJUSTMENT_DEFAULT
        parameters[:removeoutliers] = :removeoutliers in raw_parameters[:method] ? raw_parameters[:method][:removeoutliers] : Preprocessing.REMOVEOUTLIERS_DEFAULT
        parameters[:fe_sqr] = :fe_sqr in raw_parameters[:method] ? raw_parameters[:method][:fe_sqr] : nothing
        parameters[:fe_log] = :fe_log in raw_parameters[:method] ? raw_parameters[:method][:fe_log] : nothing
        parameters[:fe_inv] = :fe_inv in raw_parameters[:method] ? raw_parameters[:method][:fe_inv] : nothing
        parameters[:fe_lag] = :fe_lag in raw_parameters[:method] ? raw_parameters[:method][:fe_lag] : nothing
        parameters[:interaction] = :interaction in raw_parameters[:method] ? raw_parameters[:method][:interaction] : nothing
        parameters[:preliminaryselection] = :preliminaryselection in raw_parameters[:method] ? raw_parameters[:method][:preliminaryselection] : nothing
        parameters[:fixedvariables] = :fixedvariables in raw_parameters[:method] ? raw_parameters[:method][:fixedvariables] : AllSubsetRegression.FIXEDVARIABLES_DEFAULT
        parameters[:outsample] = :outsample in raw_parameters[:method] ? raw_parameters[:method][:outsample] : AllSubsetRegression.OUTSAMPLE_DEFAULT
        parameters[:criteria] = :criteria in raw_parameters[:method] ? raw_parameters[:method][:criteria] : AllSubsetRegression.CRITERIA_DEFAULT
        parameters[:ttest] = :ttest in raw_parameters[:method] ? raw_parameters[:method][:ttest] : AllSubsetRegression.TTEST_DEFAULT
        parameters[:ztest] = :ztest in raw_parameters[:method] ? raw_parameters[:method][:ztest] : AllSubsetRegression.ZTEST_DEFAULT
        parameters[:modelavg] = :modelavg in raw_parameters[:method] ? raw_parameters[:method][:modelavg] : AllSubsetRegression.MODELAVG_DEFAULT
        parameters[:residualtest] = :residualtest in raw_parameters[:method] ? raw_parameters[:method][:residualtest] : AllSubsetRegression.RESIDUALTEST_DEFAULT
        parameters[:orderresults] = :orderresults in raw_parameters[:method] ? raw_parameters[:method][:orderresults] : AllSubsetRegression.ORDERRESULTS_DEFAULT
        parameters[:kfoldcrossvalidation] = :kfoldcrossvalidation in raw_parameters[:method] ? raw_parameters[:method][:kfoldcrossvalidation] : CrossValidation.KFOLDCROSSVALIDATION_DEFAULT
        parameters[:numfolds] = :numfolds in raw_parameters[:method] ? raw_parameters[:method][:numfolds] : CrossValidation.NUMFOLDS_DEFAULT
        parameters[:testsetshare] = :testsetshare in raw_parameters[:method] ? raw_parameters[:method][:testsetshare] : CrossValidation.TESTSETSHARE_DEFAULT

        id = String(uuid4())
        time_enqueued = now()
        new(id, file, hash, parameters, time_enqueued, nothing, nothing, nothing)
    end
end
