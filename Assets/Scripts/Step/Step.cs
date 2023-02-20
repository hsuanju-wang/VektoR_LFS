using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Step : MonoBehaviour
{

    public GameObject[] steps;
    public int currentStepIndex;
    // Start is called before the first frame update
    void Start()
    {
        currentStepIndex = 0;
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void NextStep()
    {
        steps[currentStepIndex].SetActive(false);
        if (currentStepIndex != steps.Length - 1)
        {
            currentStepIndex++;
            steps[currentStepIndex].SetActive(true);
        }
    }

}
