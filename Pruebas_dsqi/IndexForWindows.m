
%calculate the index for windows of 4 seconds
function [kurtosis_vector,skewness_vector, power_vector, var_vector, bas_vector] = IndexForWindows(ECG)
      ecg = importdata(ECG);
      ecg_values = ecg.data;
      data = ecg_values(:,3);
      
      FS_original = 1000;
      Fs_new = 330;
      [P,Q] = rat(Fs_new/FS_original);
      data_s = resample(data,P,Q);
      %plot(data_s);

      len = length(data_s);
      window_len = 4*Fs_new;
      size_vector = round(len/window_len);
      kurtosis_vector =zeros(1,size_vector);
      skewness_vector = zeros(1,size_vector);
      power_vector = zeros(1,size_vector);
      var_vector = zeros(1,size_vector);
      bas_vector = zeros(1,size_vector);
      %falta el de baseline(basSQI)

      for i=1:(((round(len/window_len))-1))
         data_f=data_s(i*(window_len)+1:(i+1)*(window_len)+1);
         [kSQI,sSQI, pSQI, cSQI,basSQI] = IndexCalculation(data_f);
         kurtosis_vector(i) = kSQI; 
         kv_ups = upsampleVector(kurtosis_vector);
         skewness_vector(i) = sSQI;
         sv_ups = upsampleVector(skewness_vector);
         power_vector(i) = pSQI;
         pv_ups = upsampleVector(power_vector);
         var_vector(i) = cSQI;
         vv_ups = upsampleVector(var_vector);
         bas_vector(i) = basSQI;
         bv_ups = upsampleVector(bas_vector);
        
      end
          
          plot(data_s);
          hold on;
          plot(kv_ups*(50000/mean(kurtosis_vector))); %upsampling del vector y multiplicar 
          title("ECG+Kurtosis");

          figure
          plot(data_s);
          hold on;
          plot(sv_ups*(50000/mean(skewness_vector)));
          title("ECG+Skewness");
          

          figure
          plot(data_s);
          hold on;
          plot(pv_ups*(50000/mean(power_vector)));
          title("ECG+Power");

          figure
          plot(data_s);
          hold on;
          plot(vv_ups*(50000/mean(var_vector)));
          title("ECG+R-RVariability");

          figure
          plot(data_s);
          hold on;
          plot(bv_ups*(50000/mean(bas_vector)));
          title("ECG+BaseLine");

end

function [vector_ups] = upsampleVector(vector)
    Fs = 0.25;
    Fs_ecg = 330;
    [P1,Q1] = rat(Fs_ecg/Fs);
    vector_ups = resample(vector,P1,Q1);

end