using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Step : MonoBehaviour
{
    public float footPrintCloseTime;
    public GameObject[] steps;
    public int currentStepIndex;

    public GameObject task1Step;

    // Start is called before the first frame update
    void Start()
    {
        currentStepIndex = 0;
        //steps = GameObject.FindGameObjectsWithTag("step");
        for (int i = 1; i < steps.Length; i++)
        {
            steps[i].gameObject.SetActive(false);
        }
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
    }

    private IEnumerator CloseFootPrint(GameObject closingStep)
    {
        yield return new WaitForSeconds(footPrintCloseTime);
        closingStep.SetActive(false);
    }

    public void CloseAllFootPtint()
    {
        foreach (GameObject f in steps)
        {
            f.SetActive(false);
        }
    }

}
