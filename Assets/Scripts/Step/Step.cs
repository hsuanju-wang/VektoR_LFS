using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Step : MonoBehaviour
{
    public float footPrintCloseTime;
    public GameObject[] steps;
    public int currentStepIndex;

    public GameObject task1Step;
    //public GameObject task;

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
        StartCoroutine(CloseFootPrint(steps[currentStepIndex]));

        if (currentStepIndex != steps.Length - 1)
        {
            currentStepIndex++;
            steps[currentStepIndex].SetActive(true);
        }
        else // last step, show task 1 step
        {
            //task.GetComponent<ShowTask>().ShowTaskStep();
            task1Step.SetActive(true);
        }
    }

    private IEnumerator CloseFootPrint(GameObject closingStep)
    {
        yield return new WaitForSeconds(footPrintCloseTime);
        closingStep.SetActive(false);
    }

}
